require 'application_system_test_case'

class ProductCategoriesTest < ApplicationSystemTestCase
  test 'create product category and show' do
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
    visit root_path
    click_on 'Categoria de Produtos'
    click_on 'Registrar Categoria'
    click_on 'Salvar Categoria'

    assert_text 'não pode ficar em branco', count: 2
  end

  test 'code must be unique' do
    ProductCategory.create!(name: 'AntiFraude', code: 'ANTIFRA')

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

    visit root_path
    click_on 'Categoria de Produtos'

    assert_text 'AntiFraude'
    assert_text 'ANTIFRA'
  end
end
