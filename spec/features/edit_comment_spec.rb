feature 'Editing comments' do

  let(:user) do
    user = create :user
  end

  scenario 'can edit a comment when logged in to Chitter' do
    expect(Peep.count).to eq(0)
    sign_in(email: user.email,   password: user.password)
    visit '/peeps'
    fill_in 'text', with: 'peep message'
    click_button 'Submit Peep'
    click_link 'comments'
    fill_in 'text', with: 'comment message'
    click_button 'Submit'
    find("#edit_icon").click
    fill_in 'text', with: 'comment updated'
    click_button 'Submit'
    expect(page).to have_content('comment updated')
  end
end
