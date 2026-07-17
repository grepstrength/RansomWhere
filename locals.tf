locals {
  firefox_bookmarks    = var.aggregator_bookmarks
  torbrowser_bookmarks = concat(var.aggregator_bookmarks, var.onion_bookmarks)
}