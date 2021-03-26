require 'test_helper'

class ProductCategoryFlowTest < ActionDispatch::IntegrationTest
  test 'cannot create a product category without login' do
    post '/product_categories', params: { 
      product_category: { name: 'Natal', code: 'NATAL10' }
    }

    assert_redirected_to new_user_session_path
  end

  test 'cannot update a product category without login' do
    product_category = ProductCategory.create!(name: 'AntiFraude', code: 'ANTIFRA')
    patch product_category_path(product_category), params: {name: 'Natal', code: 'NATAL10' }

    assert_redirected_to new_user_session_path
  end

  test 'cannot destroy a product category without login' do
    product_category = ProductCategory.create!(name: 'AntiFraude', code: 'ANTIFRA')
    delete product_category_path(product_category)

    assert_redirected_to new_user_session_path
  end
end
