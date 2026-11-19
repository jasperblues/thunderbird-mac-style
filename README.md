# thunderbird-mac-style

**Make Thunderbird look and feel like a Mac mail client.**

A stylesheet and a few settings for [Thunderbird](https://www.thunderbird.net/) that give it a calm, Mac-style layout: a quiet sidebar, a flat message list with big unread dots, a roomy reading pane, and macOS colours. Made for people moving from Apple Mail to Linux, but it works on any platform Thunderbird runs on.

## What it changes

**Colours.** The macOS palette in light and dark mode: system blue for selection and unread mail, a grey sidebar, and secondary grey for dates and recipients.

**Sidebar.** Rounded grey selection pills, blue folder icons, account names as small section headings, and plain unread numbers instead of badges.

**Message list.** Flat rows divided by hairlines instead of boxed cards. A big blue dot for unread mail, as in Apple Mail. Semibold sender, regular subject, small grey details. The star and ⋮ buttons only appear on hover (or for flagged mail).

**Reading pane.** Space around the header and the message. Icon-only Reply, Forward and Archive buttons. Names without full addresses, no Reply-To or List-ID rows, and To, Cc and the date in grey. Plain-text mail in the normal font rather than monospace, at 16px.

**Toolbar.** Write and Get Messages on the left, a rounded search field in the middle, Archive and Delete on the right. The search field says ⌘K (see [Notes](#notes)).

## Install

Quit Thunderbird, then:

```sh
git clone https://github.com/jasperblues/thunderbird-mac-style.git
cd thunderbird-mac-style
./install.sh
```

The script finds your default profile (in `~/.thunderbird`, `~/.config/thunderbird`, the Flatpak folders, or `~/Library/Thunderbird` on macOS). To use another profile, pass its folder: `./install.sh ~/.thunderbird/abcd1234.default-release`. Thunderbird shows the folder under **Help → Troubleshooting Information → Profile Folder**.

It copies two stylesheets into the profile's `chrome` folder, adds a marked block to `user.js`, and sets the toolbar and message header layout in `xulstore.json`. Every file it changes is backed up first with a `.bak-<timestamp>` suffix.

For a unified inbox across accounts, click **⋯** above the folder list and tick **Unified Folders**.

## Uninstall

Quit Thunderbird, then run `./uninstall.sh`. It removes the stylesheets and the `user.js` block. The toolbar and header layout stay, and you can change them in Thunderbird: right-click the toolbar → **Customize**, and in a message header, **More → Customize**.

## Customise

All colours are variables at the top of [`chrome/userChrome.css`](chrome/userChrome.css), with light and dark values:

```css
--am-accent: light-dark(#007aff, #0a84ff);
--am-sidebar: light-dark(#e8e6ea, #2b2a2d);
```

Font sizes are in the **Typography** section of the same file. Edit the copy in your profile's `chrome` folder and restart Thunderbird.

## Notes

- **Thunderbird version.** Written for Thunderbird 158 with the default theme. Thunderbird's interface changes between releases, so some rules may need updating on other versions. Issues and pull requests are welcome.
- **⌘K.** The search field shows ⌘K for people who use a Mac keymap on Linux, such as [Toshy](https://github.com/RedBearAK/toshy), where Cmd+K sends Ctrl+K. Without one, the shortcut is Ctrl+K. Delete the block marked "⌘K" in `userChrome.css` to keep Thunderbird's own label.
- **Search.** `user.js` turns on Thunderbird's global search index, which some distributions (Fedora) switch off. The toolbar's search field only appears when it's on. The index builds in the background the first time.
- **Fonts.** Thunderbird uses your system interface font. It looks best with a font designed for screens, such as [Inter](https://rsms.me/inter/).
- **Thin text on Linux.** If text looks thinner than on a Mac, FreeType's stem darkening makes it closer. Add this line to `~/.config/environment.d/fonts.conf` and log in again:

  ```
  FREETYPE_PROPERTIES="cff:no-stem-darkening=0 autofitter:no-stem-darkening=0"
  ```
- **Images.** Thunderbird blocks remote images by default. To load them, go to **Settings → Privacy & Security** and tick **Allow remote content in messages**, or allow them per sender from the bar above a message.

This project is not affiliated with Apple or Mozilla.

## A note on email

This stylesheet makes Thunderbird calmer and more Mac-like, but it can only restyle what's there. Email on Linux still feels a bit dated next to Apple Mail, and Thunderbird's layout and workflow come from another era. There's room for a new mail app that feels at home on a modern desktop. Watch this space.

## License

[MIT](LICENSE)
