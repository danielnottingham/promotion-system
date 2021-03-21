require 'application_system_test_case'

class ProductCategoriesTest < ApplicationSystemTestCase
  test 'create product category' do
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
end
