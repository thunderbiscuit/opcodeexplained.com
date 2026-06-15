[doc("List all available commands")]
@list:
  just --list --unsorted

[doc("Serve the website locally")]
serve:
  pnpm run docs:dev
