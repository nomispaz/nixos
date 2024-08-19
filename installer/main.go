package main

import (
	"fmt"
	"os"
	"os/exec"
	"strconv"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
)

// TuiState is used to determine if the program should be stopped completely or just the tui to be interrupted
// -1 : close program
//
//	0 : interrupt tui
//	1 : restart tui
var TuiState int

var cmdArray [100]string

type configSettings struct {
	createNewGPT bool
	installDrive string
	efiPartition string
	rootPartition string
	formatEfiPartition bool
	formatRootPartition bool
	mode string
}

var myconfig configSettings;

type updateMsg struct {
	// array to save items that can be selected in a displayed list
	listitems []string
	// map to contain the selected items
	selected map[int]string
	// position of the cursor
	cursor int
	// header
	header string
	// footer
	footer string
}

// define Tui structure
type Tui struct {
	// array to save items that can be selected in a displayed list
	listitems []string
	// map to contain the selected items
	selected map[int]string
	// position of the cursor
	cursor int
	// string for the header
	header string
	//string for the footer
	footer string

	// save the configs in the Tui-structure itself
	configs map[string]string
	// name of the user
	username string
}

// first initialization of tui
func initTui() (t Tui) {
	return Tui{
		listitems: []string{"prepare volumes and partitions", "start install"},
		selected:  make(map[int]string),
		header:    "nomispaz nixos installer\n\n",
		footer:    "\nAvailable functions\n",
	}
}

// Perform some initial I/O, for now, parse the config file 
func (t *Tui) Init() tea.Cmd {
	return nil
}

func (t *Tui) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {

	case updateMsg:
		t.selected = msg.selected
		t.listitems = msg.listitems
		t.cursor = msg.cursor
		t.header = msg.header
		if msg.footer != "" {
			t.footer = msg.footer
		}


	// Is it a key press?
	case tea.KeyMsg:

		// What was the actual key pressed?
		switch msg.String() {

		// These keys should exit the program.
		case "ctrl+c", "q":
			TuiState = -1
			return t, tea.Quit

		// The "up" keys move the cursor up
		case "up":
			if t.cursor > 0 {
				t.cursor--
			}

			// The "down" keys move the cursor down
		case "down":
			if t.cursor < len(t.listitems)-1 {
				t.cursor++
			}

		// The spacebar (a literal space) toggle
		// the selected state for the item that the cursor is pointing at.
		case " ":
			_, ok := t.selected[t.cursor]
			if ok {
				delete(t.selected, t.cursor)
			} else {
				t.selected[t.cursor] = t.listitems[t.cursor]
			}
			
		// enter --> perform action according to selected entries
		case "enter":
			if t.selected[0] == "prepare volumes and partitions" {
				myconfig.mode = "installDrive"
				return t, tea.Cmd(func() tea.Msg {
					cmd, _ := exec.Command("bash", "-c", "lsblk -l").Output()
					// convert result byte to string and split at newline
					result := string(cmd)
					result_split := strings.Split(result, "\n")
					return updateMsg {
						header: "\nSelect install drive\n\n",
						listitems: result_split,
						selected:  make(map[int]string),
						cursor: 0,
					}
				})
			}
			if t.header == "\nGenerate new GPT partition table?\n\n" {
				myconfig.mode = "efiPartition"
				if t.selected[0] == "Yes" {
					myconfig.createNewGPT = true
					command := "echo 'Create partition table (only do this if no partition table exists!)'" +
						"; parted /dev/" + myconfig.installDrive + " mklabel gpt" +
						"; echo 'Create partitions'" +
						"; parted /dev/" + myconfig.installDrive + " mkpart 'EFInix' fat32 3MB 515MB" +
						"; parted /dev/" + myconfig.installDrive + " mkpart 'rootnix' btrfs 515MB 100%"
						cmd := exec.Command("bash", "-c", command)
						cmd.Run()
					
					return t, tea.Cmd(func() tea.Msg {
						cmd, _ := exec.Command("bash", "-c", "lsblk -l").Output()
						// convert result byte to string and split at newline
						result := string(cmd)
						result_split := strings.Split(result, "\n")
						return updateMsg {
							header: "\nEFI and root partition need to be formatted.\n" +
								"Select efi partition\n\n",
							listitems: result_split,
							selected:  make(map[int]string),
							cursor: 0,
						}
					})
				} else {
					myconfig.createNewGPT = false
					return t, tea.Cmd(func() tea.Msg {
						cmd, _ := exec.Command("bash", "-c", "lsblk -l").Output()
						// convert result byte to string and split at newline
						result := string(cmd)
						result_split := strings.Split(result, "\n")
						return updateMsg {
							header: "\nSelect efi partition\n\n",
							listitems: result_split,
							selected:  make(map[int]string),
							cursor: 0,
						}
					})			
				}
			}
			
			if t.header == "\nSelect install drive\n\n" {
				for i := range t.selected {
					myconfig.installDrive = strings.Split(t.selected[i], " ")[0]
				}
				return t, tea.Cmd(func() tea.Msg {
					return updateMsg {
						header: "\nGenerate new GPT partition table?\n\n",
						listitems: []string{"Yes", "No"},
						selected:  make(map[int]string),
						cursor: 0,
					}
				})
				
			}
			if myconfig.mode =="efiPartition" {
				for i := range t.selected {
					myconfig.efiPartition = strings.Split(t.selected[i], " ")[0]
				}
				return t, tea.Cmd(func() tea.Msg {
					cmd, _ := exec.Command("bash", "-c", "lsblk -l").Output()
					// convert result byte to string and split at newline
					result := string(cmd)
					result_split := strings.Split(result, "\n")
					return updateMsg {
						header: "\nSelect root partition\n\n",
						listitems: result_split,
						selected:  make(map[int]string),
						cursor: 0,
					}
				})
			}
			if t.header == "\nSelect root partition\n\n" {
				for i := range t.selected {
					myconfig.rootPartition = strings.Split(t.selected[i], " ")[0]
				}					
				return t, tea.Cmd(func() tea.Msg {
					return updateMsg {
						header: "\nFormat partitions\n\n",
						listitems: []string{myconfig.efiPartition, myconfig.rootPartition},
						selected:  make(map[int]string),
						cursor: 0,
					}
				})
			}
			if t.header == "\nFormat partitions\n\n" {
				for i := range t.selected {
					if t.selected[i] == "efi" {
						myconfig.formatEfiPartition = true
					}
					if t.selected[i] == "root" {
						myconfig.formatRootPartition = true
					}					
				}
			return t, tea.Cmd(func() tea.Msg {
				return updateMsg {
					header: "\nHit p to perform the drive preparation according to the following settings:\n\n" +
					"Create new GPT partition-table: " +
					strconv.FormatBool(myconfig.createNewGPT) +
					"\n" +
					"Install drive: " +
					myconfig.installDrive +
					"\n" +
					"Efi-Partition: " +
					myconfig.efiPartition +
					"\n" +
					"Root-Partition: " +
					myconfig.rootPartition +
					"\n" +
					"Format EFI partition: " +
					strconv.FormatBool(myconfig.formatEfiPartition) + 
					"\n" +
					"Format root partition: " +
					strconv.FormatBool(myconfig.formatRootPartition) +
					"\n",
					listitems: []string{""},
					selected: make(map[int]string),
					cursor: 0,
					footer: "\nAvailable functions\n" +
					"- p      : prepare drives\n" +
					"- q     : quit\n" + 
					"- Enter : execute selected item\n",
				}
			})			
		}

			// select p to perform preparation of drives according to the settings
		case "p":
			command := ""
			if myconfig.formatEfiPartition || myconfig.createNewGPT {
				command += "echo 'Format EFI partition'" +
				"; mkfs.vfat -F 32 /dev/" + myconfig.efiPartition
			}

			if myconfig.formatRootPartition || myconfig.createNewGPT {
				if command == "" {
					command += "; "
				}
				command += "echo 'Format root partition'" +
				"; mkfs.btrfs /dev/" + myconfig.rootPartition
			}

			if command == "" {
				command += "; "
			}
			command += "echo 'mount installDrive to /mnt'" +
			"; mount -o noatime,compress=zstd /dev/" + myconfig.installDrive + " /mnt"

			command += "echo 'create subvolumes'" +
			"; btrfs subvolume create /mnt/root" +
			"; btrfs subvolume create /mnt/home" +
			"; btrfs subvolume create /mnt/nix" +
			"; btrfs subvolume create /mnt/snapshots" +
			"; btrfs subvolume create /mnt/var_log" +
			"; btrfs subvolume create /mnt/swap" +
			"; echo 'unmount installDrive'" +
			"; umount /mnt" +
			"; echo 'mount subvolumes'" +
			"; mount -o noatime,compress=zstd,subvol=root /dev/" + myconfig.rootPartition + " /mnt" +
			"; mount --mkdir -o noatime,compress=zstd,subvol=home /dev/" + myconfig.rootPartition + " /mnt/home" +
			"; mount --mkdir -o noatime,compress=zstd,subvol=nix /dev/" + myconfig.rootPartition + " /mnt/nix" +
			"; mount --mkdir -o noatime,compress=zstd,subvol=snapshots /dev/" + myconfig.rootPartition + " /mnt/.snapshots" +
			"; mount --mkdir -o noatime,compress=zstd,subvol=var_log /dev/" + myconfig.rootPartition + " /mnt/var/log" +
			"; echo 'mount and create swap-partition and file'" +
			"; mount --mkdir -o noatime,compress=zstd,subvol=swap /dev/" + myconfig.rootPartition + " /mnt/swap" +
			"; btrfs filesystem mkswapfile --size 4g --uuid clear /mnt/swap/swapfile" +
			"; swapon /mnt/swap/swapfile" +
			"; mount --mkdir /dev/" + myconfig.efiPartition + " /mnt/boot/efi"

			return t, tea.ExecProcess(exec.Command("bash", "-c", command),nil)
		}
	}
	
	
	// Return the updated model to the Bubble Tea runtime for processing.
	// Note that we're not returning a command.
	return t, nil
}

func (t *Tui) View() string {
	// The header
	s := t.header

	// Iterate over our choices
	for i, choice := range t.listitems {

		// Is the cursor pointing at this choice?
		cursor := " " // no cursor
		if t.cursor == i {
			cursor = ">" // cursor!
		}

		// Is this choice selected?
		checked := " " // not selected
		if _, ok := t.selected[i]; ok {
			checked = "x" // selected!
		}

		// Render the row
		s += fmt.Sprintf("%s [%s] %s\n", cursor, checked, choice)
	}

	// The footer
	s += t.footer
	// Send the UI for rendering
	return s
}

func prepareDrives()  {	
//	command := "echo cloning repository "
}


func main()  {
	m := initTui()
	m.footer += "- q     : quit\n"
	m.footer += "- Enter : execute selected item\n"

	m.username = "simonheise"

	TuiState = 1
	myconfig.createNewGPT = false
	myconfig.formatEfiPartition = false
	myconfig.formatRootPartition = false

	for {
		if TuiState == 1 {
			p := tea.NewProgram(&m)
			_, err := p.Run()
			if err != nil {
				fmt.Printf("Program ended unexpectedly due to: %v", err)
				os.Exit(1)
			}
			if TuiState == 0 {
				TuiState = 1
			}
			if TuiState == -1 {
				break
			}
		}

	}
}
