# PluginSupport

Swift Package Plugins are unable to include resources.

As such, this library bundles those resources and, when provided as a dependency, allows access to the resources within its bundle, circumventing the restriction on Swift Package Plugins.

tl;dr: This module bundles files and includes a command to print file paths for access by Plugins.
