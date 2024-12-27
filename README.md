# window-selector.nvim

This Neovim plugin provides a simple way to select a window from multiple open windows. It displays floating selector windows that allow you to switch between different Neovim windows using keypresses.

![screenshot](/image/screenshot.png)

# Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'goropikari/window-selector.nvim'
}
```

## Usage

You can use the module to select a window by calling `require('window-selector').select_window()`. This function will display window labels and allow you to switch between windows with the keys A, B, C, etc. If an invalid key is pressed, it will return to the previously active window.

## License

This project is licensed under the MIT License.
