module UserMethods
  # Yields the block with user as the current user
  def with_current_user(user, &block)
    saved_user = User.current
    allow(User).to receive(:current).and_return(user)
    yield
  ensure
    #not original, it is probably already stubed
    allow( User ).to receive(:current).and_return(saved_user)
  end

  def logged_user(user)
    allow( User ).to receive(:current).and_return(user)
  end

end
