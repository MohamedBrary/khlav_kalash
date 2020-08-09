require 'application_system_test_case'

class OrdersTest < ApplicationSystemTestCase
  setup do
    @order = orders(:one)
  end

  test 'visiting the index' do
    authenticated_visit(orders_path)
    assert_selector 'h1', text: 'Orders'
  end

  test 'creating a Order' do
    authenticated_visit(orders_path)
    click_on 'New Order'

    @order.destroy # to avoid uniqueness violations
    select @order.country, from: 'Country'
    fill_in 'Email address', with: @order.email_address
    fill_in 'First name', with: @order.first_name
    fill_in 'Last name', with: @order.last_name
    fill_in 'Postal code', with: @order.postal_code
    click_on "Pay #{@order.price.format}"

    assert_text 'Order was successfully created'
  end

  test 'updating a Order' do
    authenticated_visit(orders_path)
    click_on 'Edit', match: :first

    fill_in 'Email address', with: @order.email_address
    fill_in 'First name', with: @order.first_name
    fill_in 'Last name', with: @order.last_name
    fill_in 'Postal code', with: @order.postal_code
    click_on "Pay #{@order.price.format}"

    assert_text 'Order was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Order' do
    authenticated_visit(orders_path)
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Order was successfully destroyed'
  end

  private

  # to bypass basic authentication
  # https://stackoverflow.com/a/29703214/426845
  def authenticated_visit(page_path)
    username = ENV['ADMIN_USER_NAME']
    password = ENV['ADMIN_PASSWORD']
    login = "#{username}:#{password}@"
    base_url = "#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}/"

    visit "http://#{login}#{base_url}#{page_path}"
  end

end
