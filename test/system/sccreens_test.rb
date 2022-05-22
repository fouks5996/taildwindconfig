require "application_system_test_case"

class SccreensTest < ApplicationSystemTestCase
  setup do
    @sccreen = sccreens(:one)
  end

  test "visiting the index" do
    visit sccreens_url
    assert_selector "h1", text: "Sccreens"
  end

  test "creating a Sccreen" do
    visit sccreens_url
    click_on "New Sccreen"

    click_on "Create Sccreen"

    assert_text "Sccreen was successfully created"
    click_on "Back"
  end

  test "updating a Sccreen" do
    visit sccreens_url
    click_on "Edit", match: :first

    click_on "Update Sccreen"

    assert_text "Sccreen was successfully updated"
    click_on "Back"
  end

  test "destroying a Sccreen" do
    visit sccreens_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sccreen was successfully destroyed"
  end
end
