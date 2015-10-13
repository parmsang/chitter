feature 'Deleting peeps' do

  let(:user) do
    user = create :user
  end

  scenario 'can delete a peep when logged in to Chitter' do
    sign_in(email: user.email,   password: user.password)
    visit '/peeps/new_peep'
    fill_in 'text', with: 'peep message'
    click_button 'Submit peep'
    expect(page).to have_content('peep message')
    find("#trash_icon").click
    expect(page).not_to have_content('peep message')
  end
end
