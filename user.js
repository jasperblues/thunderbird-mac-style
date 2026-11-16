// thunderbird-mac-style: applied every time Thunderbird starts.
// Remove a line to stop forcing that setting.

// Load chrome/userChrome.css and chrome/userContent.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Three columns: folders | messages | reading pane
user_pref("mail.pane_config.dynamic", 2);

// Message list as cards (sender, subject, details) rather than a table
user_pref("mail.threadpane.listview", 0);

// Message text at 16px, and plain-text mail in the normal font, not monospace
user_pref("font.size.variable.x-western", 16);
user_pref("mail.fixed_width_messages", false);

// The global search index, which also gives the toolbar its search field.
// Some distributions (Fedora) turn it off. It builds in the background.
user_pref("mailnews.database.global.indexer.enabled", true);
