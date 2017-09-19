require 'spec_helper'
require 'shared_contexts'

describe 'nginx::firewall::http' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it do
        is_expected.to contain_firewall("100 allow http")
            .with({
              "dport" => "80",
              "proto" => "tcp",
              "action" => "accept",
              })
      end
    end
  end
end
