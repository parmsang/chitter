feature 'Deleting comments' do

  let(:user) do
    user = create :user
  end

  scenario 'can delete a his/her comment when logged in to Chitter' do
    sign_in(email: user.email,   password: user.password)
    visit '/peeps'
    fill_in 'text', with: 'peep message'
    click_button 'Submit Peep'
    click_link 'comments'
    fill_in 'text', with: 'comment message'
    click_button 'Submit'
    find("#trash_icon").click
    expect(page).not_to have_content('comment message')
  end
end
