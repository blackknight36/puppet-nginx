require 'spec_helper'
require 'shared_contexts'

describe 'nginx::firewall::https' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it do
        is_expected.to contain_firewall("100 allow https")
            .with({
              "dport" => "443",
              "proto" => "tcp",
              "action" => "accept",
              })
      end
    end
  end
end
