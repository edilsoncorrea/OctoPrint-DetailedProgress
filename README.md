# OctoPrint-DetailedProgress - Enhanced CB1 Compatibility

A plugin that sends M117 (and optionally M73) commands to the printer to display the progress of the print job being currently streamed. The message to display can be configured (some placeholders included).

**Version 0.2.8** - Now with enhanced compatibility for CB1 BTT boards and virtual environment installations.

![Example ETA](https://i.imgur.com/ocBp152.jpg)
![Example ETL](https://i.imgur.com/oJiMm2p.jpg)
![Example Percent](https://i.imgur.com/McaCNsx.jpg)
![Example M73 Prusa](https://i.imgur.com/C1zeANH.jpg)

## 🔧 CB1 BTT Compatibility

This version specifically addresses issues with CB1 BTT boards where the plugin would appear disabled after installation. If you're using a CB1 with OctoPrint in a virtual environment, use the enhanced installation method below.

### ✅ Enhanced Features for CB1:
- Robust virtual environment detection
- Improved error handling and logging
- Automatic environment validation
- Dedicated diagnostic tools
- CB1-specific installation script

## 📦 Setup

### For CB1 BTT Boards (Recommended Method)

1. **SSH into your CB1:**
```bash
ssh pi@<cb1-ip-address>
```

2. **Download the enhanced version:**
```bash
cd ~
git clone https://github.com/edilsoncorrea/OctoPrint-DetailedProgress.git
cd OctoPrint-DetailedProgress
```

3. **Run automated installation:**
```bash
chmod +x install_cb1.sh
./install_cb1.sh
```

### For Standard Raspberry Pi

Install manually using this URL in OctoPrint Plugin Manager:
```
https://github.com/edilsoncorrea/OctoPrint-DetailedProgress/archive/master.zip
```

Or via command line:
```bash
source ~/oprint/bin/activate
pip install https://github.com/edilsoncorrea/OctoPrint-DetailedProgress/archive/master.zip
```

## 🛠️ Troubleshooting CB1 Issues

If the plugin shows as disabled on your CB1:

1. **Run the diagnostic tool:**
```bash
cd OctoPrint-DetailedProgress
source ~/OctoPrint/venv/bin/activate
python diagnostic_tool.py
```

2. **Check your environment:**
```bash
source ~/OctoPrint/venv/bin/activate
echo $VIRTUAL_ENV  # Should show your OctoPrint venv
python -c "import octoprint; print('✓ OctoPrint available')"
```

3. **Verify installation:**
```bash
pip list | grep -i detailed
```

4. **Check logs:**
```bash
tail -f ~/.octoprint/logs/octoprint.log
```

Look for messages like:
- `✓ OctoPrint-DetailedProgress loaded!`
- `✓ Plugin initialization completed successfully`

## ⚙️ Configuration

Access plugin settings via: **OctoPrint Settings** → **Plugins** → **Detailed Progress**

### Available Settings:
- **Time to change**: Interval between message cycles (seconds)
- **ETL Format**: Format for "Estimated Time Left" display
- **ETA Format**: Format for "Estimated Time of Arrival" 
- **Messages**: Customize displayed information
- **M73 Support**: Enable Prusa-style progress reporting
- **Show IP at startup**: Display IP address on LCD at startup

### Available Variables:
- `{completion}` - Completion percentage (0-100)
- `{printTimeLeft}` - Estimated time remaining
- `{ETA}` - Estimated completion time
- `{accuracy}` - Accuracy indicator for time estimates
- `{filename}` - Current file name
- `{layerProgress}` - Layer progress (requires DisplayLayerProgress)
- `{heightProgress}` - Height progress
- `{changeFilamentIn}` - Time until filament change

## 🔗 Dependencies for Layer Progress [Optional] 

For layer progress, height progress, or filament change timing, install [DisplayLayerProgress](https://plugins.octoprint.org/plugins/DisplayLayerProgress).

**Note**: Disable 'Printer Display' in DisplayLayerProgress settings to avoid conflicts.

## 🎯 Supported Printers

Works with any printer supporting:
- **M117** commands (LCD message display) - Required
- **M73** commands (progress reporting) - Optional

### Tested Printers:
- Prusa i3 MK2/MK3/MK4
- Ender 3/5 series (with appropriate firmware)
- Artillery Sidewinder
- Many others with Marlin/RepRap firmware

## 🐛 Troubleshooting

### Common Issues:

**Plugin disabled after installation (CB1):**
- Use the `install_cb1.sh` script
- Run diagnostic tool for detailed analysis

**No messages on LCD:**
- Verify printer firmware supports M117
- Test with: `M117 Test Message` in OctoPrint terminal

**Inaccurate time estimates:**
- Let OctoPrint analyze your printer over several prints
- Check "Accuracy" setting in messages

**Permission errors (CB1):**
- Ensure you're using the OctoPrint virtual environment
- Check file permissions in `~/.octoprint`

## 📋 Requirements

- **OctoPrint**: 1.3.0 or higher
- **Python**: 3.7 or higher (2.7 support removed)
- **Printer**: Must support M117 commands
- **For M73**: Printer firmware with M73 support

## 💡 Tips for CB1 Users

1. **Always activate the venv first:**
   ```bash
   source ~/OctoPrint/venv/bin/activate
   ```

2. **Monitor logs during first print:**
   ```bash
   tail -f ~/.octoprint/logs/octoprint.log
   ```

3. **Use the diagnostic tool if issues arise:**
   ```bash
   python diagnostic_tool.py
   ```

4. **Check plugin status in web interface:**
   Settings → Plugin Manager → Look for "Detailed Progress"

## 📚 Additional Files

- **[INSTALACAO_CB1.md](INSTALACAO_CB1.md)**: Detailed CB1 installation guide (Portuguese)
- **diagnostic_tool.py**: Troubleshooting and environment analysis
- **install_cb1.sh**: Automated installation script for CB1

## 🤝 Contributing

Found an issue? Please include:
1. Output from `diagnostic_tool.py`
2. Relevant log excerpts
3. Hardware details (Pi model, CB1, printer)
4. OctoPrint and Python versions

## 📄 License

AGPLv3 - See [LICENSE](LICENSE) for details

## 🎉 Credits

- **Original Author**: Tom M (tpmullan)
- **CB1 Enhanced Fork**: Edilson Correa (edilsoncorrea117@gmail.com)
- **Repository**: https://github.com/edilsoncorrea/OctoPrint-DetailedProgress
- **Special Thanks**: BTT and OctoPrint communities

---

**Version 0.2.8 Changelog:**
- ✅ Enhanced CB1 BTT compatibility
- ✅ Robust virtual environment detection  
- ✅ Improved error handling and logging
- ✅ Python 3.7+ requirement (dropped 2.7 support)
- ✅ Diagnostic tools and automated installation
- ✅ Better initialization checks and fallbacks

2. **Check your environment:**
```bash
source ~/OctoPrint/venv/bin/activate
echo $VIRTUAL_ENV  # Should show your OctoPrint venv
python -c "import octoprint; print('✓ OctoPrint available')"
```

3. **Verify installation:**
```bash
pip list | grep -i detailed
```

4. **Check logs:**
```bash
tail -f ~/.octoprint/logs/octoprint.log
```

Look for messages like:
- `✓ OctoPrint-DetailedProgress loaded!`
- `✓ Plugin initialization completed successfully`

## ⚙️ Configuration 

If you also want to display layer progress, height progress or time to filament change, you will have to install the plugin [DisplayLayerProgress](https://plugins.octoprint.org/plugins/DisplayLayerProgress).
Follow setup instructions for that plugin.

You will probably want to disable 'Printer Display' in the settings for DisplayLayerProgress.

## Configuration

### Manual Config File
``` yaml
plugins:
  detailedprogress:
    # Number of seconds (minimum) to rotate the messages
    time_to_change: 10
    eta_strftime: "%H:%M:%S Day %d"
    etl_format: "{hours:02d}:{minutes:02d}:{seconds:02d}"
    # Send M73 progress commands 
    use_M73: true
    # Send the 'R' parameter for M73 commands (supported in Marlin when compiled with LCD_SET_PROGRESS_MANUALLY and Prusa firmware > 3.3.0)
    use_M73_R: true
    # Messages to display. Placeholders:
    # - completion : The % completed
    # - printTime : A string in the format "HH:MM:SS" with how long the print is going
    # - printTimeLeft : A string in the format "HH:MM:SS" with how long the print still has left
    # - ETA : The date and time formatted in "%H:%M:%S Day %d" that the print is estimated to be completed
    # - filepos: The current position in the file currently being printed
    # - filename: The filename of file currently being printed
    # - accuracy: Accuracy of the time estimates
    messages:
      - "{completion:.2f}% complete"
      - "ETL: {printTimeLeft}"
      - "ETA: {ETA}"
    print_done_message: "Print Done"
```
### Plugin Settings menu

![Example Settings](https://i.imgur.com/wdFGGrN.jpg)

### Time Variables:

* The eta_strftime uses built in python functions to format the time, examples can be found [here](https://strftime.org/).  
* Be careful when using the character `:` in the messages, some firmwares will [expect a checksum and crash](https://community.octoprint.org/t/error-no-checksum-with-line-number-last-line-18/8838/2).  To fix this issues either omit the character or update to the latest version of Marlin.

### Layer progress etc.
If you chose to install [DisplayLayerProgress](https://plugins.octoprint.org/plugins/DisplayLayerProgress), enable one or all of:

* Layer {layerProgress} 
* Height {heightProgress}
* Fil. change {changeFilamentIn}
