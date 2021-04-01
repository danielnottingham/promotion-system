require "test_helper"

class UserTest < ActiveSupport::TestCase
  test 'when email domain is valid' do
    user = User.create(email: 'daniel@iugu.com.br', password: 'password')

    assert user.valid?
  end

  test 'when email domain is invalid' do
    user = User.create(email: 'daniel@gmail.com.br', password: 'password')

    refute user.valid?
    assert user.errors.full_messages, 'Domínio do email deve ser "@iugu.com.br"'
  end
end
