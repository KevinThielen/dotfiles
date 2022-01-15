call plug#begin()

" Util
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf.vim'
Plug 'DougBeney/pickachu'
"
" Org
Plug 'vimwiki/vimwiki'

" Programming
Plug 'rust-lang/rust.vim'  "things like :Cargo 
Plug 'simrat39/rust-tools.nvim'  "inplay and stuff
Plug 'cespare/vim-toml'
Plug 'neovim/nvim-lspconfig'


Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/vim-vsnip'

Plug 'preservim/tagbar'
Plug 'preservim/nerdcommenter'

call plug#end()
filetype plugin indent on    " required
filetype plugin on           " required


"*******************************
"           GENERAL            "
"*******************************
set textwidth=100
set tabstop=4
set shiftwidth=4
set expandtab
set cursorline



"*******************************
"          DEBUGGER            "
"*******************************
packadd! termdebug
let g:termdebug_wide=-1
tnoremap <Esc> <C-\><C-n>

"*******************************
"       COLOR THEME            "
"*******************************
if (has("termguicolors"))
 set termguicolors
endif

colorscheme shades_of_purple

"*******************************
"        clipboard             "
"*******************************
set clipboard+=unnamedplus



"*******************************
"           ORG                "
"*******************************
let g:vimwiki_list = [{'path':'~/org', 'syntax':'markdown', 'ext':'.md'}]
let g:vimwiki_ext2syntax = {'.md':'markdown', '.markdown': 'markdown', 'mdown': 'markdown'}
let g:vimwiki_markdown_link_ext = 1
let g:vimwiki_folding = 'syntax'
let g:markdown_folding = 1
let g:taskwiki_markup_syntax = 'markdown'
let g:vimwiki_global_ext = 0
"*******************************
"           FZF                "
"*******************************
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let g:fzf_action = {
  \ 'ctrl-t': 'tab drop',
  \ 'ctrl-x': 'split',
  \ 'ctrl-o': 'vsplit' }

"*******************************
"       NERD TREE              "
"*******************************
let g:NERDTreeWinPos ="right"

"*******************************
"          TAGBAR              "
"*******************************
let g:tagbar_autofocus=1
let g:tagbar_autoclose=1

"*******************************
"           LSP                "
"*******************************
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

lua <<EOF

 local opts = {
     tools = { -- rust-tools options
         autoSetHints = true,
         hover_with_actions = true,
         inlay_hints = {
             show_parameter_hints = false,
             parameter_hints_prefix = "",
             other_hints_prefix = "",
         },
     },
     -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
     server = {
         -- on_attach is a callback called when the language server attachs to the buffer
         -- on_attach = on_attach,
         settings = {
             ["rust-analyzer"] = {
                 -- enable clippy on save
                 checkOnSave = {
                     command = "clippy"
                 },
             }
         }
     },
 }
 require('rust-tools').setup(opts)

EOF

lua <<EOF
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})

EOF


autocmd DiagnosticChanged * lua vim.diagnostic.setqflist({open = false })

"*******************************
"            Hide              "
"*******************************
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction

"*******************************
"           Keymaps            "
"*******************************
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>t :NERDTreeToggle<CR>
nnoremap <silent> <leader><S-t> :TagbarToggle<CR>

vnoremap <silent> <leader>s c~~~~<ESC>hhp
nnoremap <silent> <leader>s ciw~~~~<ESC>hhp
nnoremap <silent> <leader>b ciw****<ESC>hhp
nnoremap <silent> <leader>i ciw**<ESC>hp
vnoremap <silent> <leader>ct ~<ESC>
nnoremap <S-h> :call ToggleHiddenAll()<CR>

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> gK    <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>

" Goto previous/next diagnostic warning/error
let s:hidden_qfix = 0
function! ToggleQFix()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        copen
    else 
        cclose
        let s:hidden_all = 0
    endif
endfunction


nnoremap <silent> <leader>g :call ToggleQFix()<CR>
nnoremap <silent> g[ <cmd>cnext<CR>
nnoremap <silent> g] <cmd>cprevious<CR>
