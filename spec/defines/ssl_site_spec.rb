require 'spec_helper'
require 'shared_contexts'

describe 'nginx::ssl_site' do
  let(:title) { 'www.example.com' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context "manage_firewall => true" do
        let(:params) {{
          :manage_firewall => true
        }}

        it { is_expected.to contain_class('nginx::firewall::https') }
      end

      it { is_expected.to contain_file("/etc/nginx/conf.d/#{title}.ssl.conf") }

      it do
        is_expected.to contain_file("/etc/pki/tls/certs/#{title}.crt")
            .with({
              "content" => /-----BEGIN CERTIFICATE-----/,
              "mode" => "0444",
              })
      end

      it do
        is_expected.to contain_file("/etc/pki/tls/private/#{title}.key")
            .with({
              "content" => /-----BEGIN RSA PRIVATE KEY-----/,
              "mode" => "0440",
              })
      end
    end
  end
end
