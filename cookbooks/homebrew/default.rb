package 'envchain'
package 'openssl@1.1'
package 'jid'
package 'gist'
package 'direnv'
package 'autojump'
package 'gron'
package 'tig'
package 'hugo'
package 'tree'
package 'telnet'
package 'ngrep'
package 'entr'
package 'jq'
package 'ghq'
package 'bat'
package 'go'
package 'github/gh/gh'
package 'noti'

execute 'brew tap kyoshidajp/ghkw'
package 'ghkw'

execute 'brew tap ktr0731/evans'
package 'evans'

package 'global' do
  options '--with-exuberant-ctags --with-pygments'
end
