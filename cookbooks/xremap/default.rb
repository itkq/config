node.reverse_merge!(
  xremap: {
    repo_path: "#{ENV['HOME']}/src/github.com/itkq/xremap",
  }
)
package 'bison'
package 'libx11-dev'
package 'ruby'

git node[:xremap][:repo_path] do
  repository 'https://github.com/itkq/xremap'
  not_if 'which xremap'
  user node[:user]
end

execute 'make && make install' do
  cwd node[:xremap][:repo_path]
  not_if 'which xremap'
end

template "#{ENV['HOME']}/.config/systemd/user/xremap.service" do
  source 'templates/xremap.service'
end

user_service 'xremap' do
  action [:enable, :start]
end

package 'wmctrl'

dotfile '.xremap'
