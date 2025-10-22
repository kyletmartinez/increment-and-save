# Increment and Save

A macOS Automator Quick Action that automatically increments version numbers in filenames and archives the previous version.

## Overview

This tool streamlines version control for individual files by:
- Duplicating your file with an incremented version number
- Moving the original file to an `_Archive` folder (if it exists)
- Maintaining your existing filename structure

**Example:**
- Original: `project_design_v01.psd`
- Result: `project_design_v02.psd` (new working file)
- Archive: `project_design_v01.psd` (moved to `_Archive/`)

## Requirements

- macOS (uses `osascript` for notifications)
- Filename must follow the pattern: `name_with_underscores_v##.ext`
  - Version numbers can be any digit length (e.g., `v01`, `v02`, `v100`)
  - Must end with underscore + version + extension

## Installation

### 1. Download the Script

Clone this repository or download `main.sh`:

```bash
git clone https://github.com/yourusername/increment-and-save.git
```

### 2. Create Automator Quick Action

1. Open **Automator** (Applications > Automator)
2. Choose **New Document** and select **Quick Action**
3. Configure the workflow settings at the top:
   - **Workflow receives current:** `files or folders`
   - **in:** `Finder`
4. Add a **Run Shell Script** action:
   - Search for "Run Shell Script" in the actions library
   - Drag it into the workflow area
5. Configure the Run Shell Script action:
   - **Shell:** `/bin/sh`
   - **Pass input:** `as arguments`
6. Copy the contents of `main.sh` and paste it into the script area
7. Save the Quick Action:
   - **File > Save** (⌘S)
   - Name it: `Increment and Save`
   - The workflow will be saved to `~/Library/Services/`

### 3. Optional: Customize Appearance

In the workflow settings (top of Automator):
- **Image:** Documents (or choose your preferred icon)
- **Color:** Black (or your preferred color)

## Usage

### Basic Usage

1. In **Finder**, locate a file with a version number (e.g., `report_draft_v01.docx`)
2. **Right-click** (or Control-click) the file
3. Navigate to **Quick Actions > Increment and Save**
4. The script will:
   - Create `report_draft_v02.docx` in the same location
   - Move `report_draft_v01.docx` to `_Archive/` (if the folder exists)
   - Display a notification when complete

### Setting Up Archive Folder

For automatic archiving, create an `_Archive` folder in the same directory as your versioned files:

```bash
mkdir _Archive
```

If the `_Archive` folder doesn't exist, the script will still create the new version but won't move the old file.

## Filename Requirements

### Valid Filenames
- ✅ `document_v01.pdf`
- ✅ `project_final_v05.txt`
- ✅ `design_mockup_v100.psd`
- ✅ `my_file_name_here_v03.docx`

### Invalid Filenames
- ❌ `document-v01.pdf` (uses hyphens instead of underscores)
- ❌ `projectv01.pdf` (missing underscore before version)
- ❌ `project.pdf` (no version number)

## How It Works

1. **Parses** the filename to extract components
2. **Extracts** the current version number (e.g., `v01`)
3. **Converts** from octal to decimal if needed (handles leading zeros)
4. **Increments** the version number by 1
5. **Reformats** with leading zeros (maintains 2-digit format)
6. **Duplicates** the file with the new version number
7. **Archives** the original file (if `_Archive/` exists)
8. **Notifies** you when complete

## Error Handling

The script will display error notifications for:
- No file provided
- File doesn't exist
- Filename doesn't contain underscores
- No valid version number found (must be in format `v##`)

## Troubleshooting

### Quick Action doesn't appear in menu
- Make sure the workflow is saved in `~/Library/Services/`
- Check that "Workflow receives current" is set to "files or folders"
- Try logging out and back in, or restart Finder

### Script doesn't work
- Verify your filename follows the required pattern
- Check that the file has proper permissions
- Look for error notifications from the script

### Archive folder not working
- Ensure the folder is named exactly `_Archive` (with underscore)
- Check that it's in the same directory as your file
- Verify folder permissions

## Keyboard Shortcut (Optional)

You can assign a keyboard shortcut to the Quick Action:

1. Open **System Preferences/Settings > Keyboard > Shortcuts**
2. Select **Services** in the left sidebar
3. Scroll to find **Increment and Save** under "Files and Folders"
4. Click to the right of the name and press your desired key combination

## License

MIT License - Feel free to modify and distribute as needed.

## Contributing

Issues and pull requests are welcome! Please feel free to contribute improvements or report bugs.

## Acknowledgments

Built for macOS using Bash and Automator to streamline file versioning workflows.