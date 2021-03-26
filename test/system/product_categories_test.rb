require 'application_system_test_case'

class ProductCategoriesTest < ApplicationSystemTestCase
  test 'create product category and show' do
    login_user
    visit root_path
    click_on 'Categoria de Produtos'
    click_on 'Registrar Categoria'
    fill_in 'Nome', with: 'Antifraude'
    fill_in 'Código', with: 'ANTIFRA'
    click_on 'Salvar Categoria'  
    assert_current_path product_category_path(ProductCategory.last)
    assert_text 'Antifraude'
    assert_text 'ANTIFRA'
    assert_link 'Voltar'
  end

  test 'create and attributes cannot be blank' do
    login_user
    visit root_path
    click_on 'Categoria de Produtos'
    click_on 'Registrar Categoria'
    click_on 'Salvar Categoria'

    assert_text 'não pode ficar em branco', count: 2
  end

  test 'code must be unique' do
    ProductCategory.create!(name: 'AntiFraude', code: 'ANTIFRA')

    login_user
    visit root_path
    click_on 'Categoria de Produtos'
    click_on 'Registrar Categoria'
    fill_in 'Nome', with: 'AntiFraude'
    fill_in 'Código', with: 'ANTIFRA'
    click_on 'Salvar Categoria'

    assert_text 'deve ser único', count: 1
  end

  test 'show product category list' do
    ProductCategory.create!(name: 'AntiFraude', code: 'ANTIFRA')
    
    login_user
    visit root_path
    click_on 'Categoria de Produtos'

    assert_text 'AntiFraude'
    assert_text 'ANTIFRA'
  end

  test 'expect success in edit product category' do
    product_category = ProductCategory.create!(name: 'AntiFraude', code: 'ANTIFRA')

    login_user
    visit product_category_path(product_category)
    click_on 'Editar'
    fill_in 'Nome', with: 'NovoTeste'
    fill_in 'Código', with: 'NOVOTEST'
    click_on 'Salvar Categoria'

    assert_text 'NovoTeste'
    assert_text 'NOVOTEST'
    assert_link 'Voltar'
  end

  test 'expect fail in edit product category' do
    product_category = ProductCategory.create!(name: 'AntiFraude', code: 'ANTIFRA')

    login_user
    visit product_category_path(product_category)
    click_on 'Editar'
    fill_in 'Nome', with: ''
    fill_in 'Código', with: ''
    click_on 'Salvar Categoria'

    assert_text 'não pode ficar em branco', count: 2
  end

  test 'destroy a product category' do
    ProductCategory.create!(name: 'AntiFraude', code: 'ANTIFRA')

    login_user
    visit product_categories_path
    accept_confirm 'Você tem certeza?' do
      click_on 'Deletar', match: :first
    end

    assert_select 'td', count: 0
    assert ProductCategory.count, 0
    assert_current_path product_categories_path
  end

  test 'do not view product category link without login' do
    visit root_path

    assert_no_link 'Categoria de Produtos'
  end

  test 'do not view product categories using route without login' do
    visit product_categories_path

    assert_current_path new_user_session_path
  end

  test 'can not create product category without login' do
    visit new_product_category_path
    assert_current_path new_user_session_path
  end
end
