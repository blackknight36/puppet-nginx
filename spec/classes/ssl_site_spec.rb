require 'spec_helper'
require 'shared_contexts'

describe 'nginx::ssl_site' do
  let(:node) { 'mdct-test.dartcontainer.com' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to contain_file("/etc/nginx/conf.d/#{node}.ssl.conf") }

      it do
        is_expected.to contain_file("/etc/pki/tls/certs/#{node}.crt")
            .with({
              "source" => "puppet:///modules/files/private/#{node}/ssl/#{node}.crt",
              "mode" => "0444",
              })
      end

      it do
        is_expected.to contain_file("/etc/pki/tls/private/#{node}.key")
            .with({
              "source" => "puppet:///modules/files/private/#{node}/ssl/#{node}.key",
              "mode" => "0440",
              })
      end
    end
  end
end
