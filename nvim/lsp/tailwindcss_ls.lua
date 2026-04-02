-- brew install tailwindcss-language-server
return {
  cmd = { 'tailwindcss-language-server', '--stdio' },
  filetypes = {
    'html',
    'css',
    'scss',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'elixir',
    'heex',
  },
  -- Tailwind v4: LSP scans for CSS files with @import "tailwindcss"
  root_markers = { 'mix.exs', '.git' },
  settings = {
    tailwindCSS = {
      classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass' },
      -- Include CSS paths for umbrella apps
      files = {
        include = { 'apps/*/assets/css/**/*.css' },
      },
      validate = true,
    },
  },
}
