# PluginSupport

## Notes

- This package uses `SwiftFormat` directly to support formatting. See `scripts/git-hookes/pre-commit` for an example.

## Frequently Asked Questions

### Why are these resources not included in the [swift-kipple/Plugins](https://github.com/swift-kipple/Plugins) repository?

Swift Package Plugins are unable to include resources.

As such, this library bundles those resources and, when provided as a dependency, allows access to the resources within its bundle, circumventing the restriction on Swift Package Plugins.

tl;dr: This module bundles files and includes a command to print file paths for access by Plugins.

### Why not just include this package within the [swift-kipple/Plugins](https://github.com/swift-kipple/Plugins) repository directly?

Unfortunately, this doesn't appear to be possible at time of writing. Referencing a remote repository that uses a relative path returns an error:

More information can be found on [this Swift forum thread](https://forums.swift.org/t/unable-to-integrate-a-remote-package-that-has-local-packages/53146
).

Until an alternative is identified, these files are provided as a standalone package.
