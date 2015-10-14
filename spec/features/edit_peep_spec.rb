feature 'Editing peeps' do

  let(:user) do
    user = create :user
  end

  scenario 'can edit a peep when logged in to Chitter' do
    sign_in(email: user.email,   password: user.password)
    visit '/peeps/new_peep'
    fill_in 'text', with: 'peep message'
    click_button 'Submit peep'
    expect(page).to have_content('peep message')
    find("#edit_icon").click
    fill_in 'text', with: 'peep updated'
    click_button 'Submit peep'
    expect(page).to have_content('peep updated')
  end
end
