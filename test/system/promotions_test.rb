require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  test 'view promotions' do
    # arrange
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)

    # act
    visit root_path
    click_on 'Promoções'

    # assert
    assert_text 'Natal'
    assert_text 'Promoção de Natal'
    assert_text '10,00%'
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
  end

  test 'view promotion details' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
  end

  test 'no promotion are available' do
    login_user
    visit root_path
    click_on 'Promoções'

    assert_text 'Nenhuma promoção cadastrada'
  end

  test 'view promotions and return to home page' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    
    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    assert_current_path root_path
  end

  test 'view details and return to promotions page' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    assert_current_path promotions_path
  end

  test 'create promotion' do
    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Salvar promoção'

    # assert_current_path promotion_path(Promotion.last)
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
    assert_link 'Voltar'
  end

  test 'create and attributes cannot be blank' do
    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    click_on 'Salvar promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'create and code/name must be unique' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: 'Natal'
    fill_in 'Código', with: 'NATAL10'
    click_on 'Salvar promoção'

    assert_text 'já está em uso', count: 2
  end

  test 'generate coupons for a promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    promotion.create_promotion_approval(user: User.create!(email: 'marcos@iugu.com.br', password: '123456'))

    visit promotion_path(promotion)
    click_on 'Gerar cupons'

    assert_text 'Cupons gerados com sucesso'
    assert_no_link 'Gerar cupons'
    assert_no_text 'NATAL10-0000'
    assert_text 'NATAL10-0001 (ativo)'
    assert_text 'NATAL10-0002 (ativo)'
    assert_text 'NATAL10-0100 (ativo)'
    assert_no_text 'NATAL10-0101'
    assert_link 'Desabilitar', count: 100
  end

  test 'edit attributes' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)
    click_on 'Editar'
    fill_in 'Nome', with: 'Black Friday'
    fill_in 'Descrição', with: 'Promoção da Black Friday'
    fill_in 'Código', with: 'BLACK30'
    fill_in 'Desconto', with: 30
    fill_in 'Quantidade de cupons', with: 50
    fill_in 'Data de término', with: '30/11/2033'
    click_on 'Salvar promoção'

    assert_text 'Black Friday'
    assert_text 'Promoção da Black Friday'
    assert_text '30,00%'
    assert_text 'BLACK30'
    assert_text '30/11/2033'
    assert_text '20'
    assert_link 'Voltar'
  end

  test 'edit attributes cannot be blank' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)
    click_on 'Editar'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    fill_in 'Desconto', with: ''
    fill_in 'Quantidade de cupons', with: ''
    fill_in 'Data de término', with: ''
    click_on 'Salvar promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'should destroy promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotions_path
    accept_confirm 'Você tem certeza?' do
      click_on 'Deletar', match: :first
    end

    assert_select 'td', count: 0
    assert Promotion.count, 0
    assert_current_path promotions_path
  end

  test 'do not view promotion link without login' do
    visit root_path

    assert_no_link 'Promoções'
  end

  test 'do not view promotions using route without login' do
    visit promotions_path

    assert_current_path new_user_session_path
  end

  test 'user approve promotion' do
    user = User.create!(email: 'test@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    approver = login_user
    visit promotion_path(promotion)
    accept_confirm { click_on 'Aprovar' }

    assert_text 'Promoção aprovada com sucesso'
    assert_text "Aprovada por: #{approver.email}"
    assert_text 'Gerar cupons'
    refute_link 'Aprovar'
  end

  test 'user cannot approves his promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)

    refute_link 'Aprovar'
    refute_link 'Gerar cupons'
  end

  test 'do view promotion details without login' do
    user = User.create!(email: 'test@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, 
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)

    assert_current_path new_user_session_path
  end

  test 'can not create promotion without login' do
    visit new_promotion_path
    assert_current_path new_user_session_path
  end

  test 'can search promotion by exactly name' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal',
                              description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10, 
                              coupon_quantity: 100,
                              expiration_date: '22/12/2033', user: user)
    visit promotions_path

    fill_in 'Pesquisa', with: 'Natal'
    click_on 'Buscar'

    assert_text 'Natal'
    assert_text 'Promoção de Natal'
    assert_text '10,00%'
  end

  test 'can search promotion by a part of the name' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal',
                              description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10, 
                              coupon_quantity: 100,
                              expiration_date: '22/12/2033', user: user)
    visit promotions_path

    fill_in 'Pesquisa', with: 'al'
    click_on 'Buscar'

    assert_text 'Natal'
    assert_text 'Promoção de Natal'
    assert_text '10,00%'
  end

  test 'did not find a registered promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal',
                              description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10, 
                              coupon_quantity: 100,
                              expiration_date: '22/12/2033', user: user)
    visit promotions_path

    fill_in 'Pesquisa', with: 'ge'
    click_on 'Buscar'

    assert_text 'Nenhuma promoção cadastrada'
  end
end
