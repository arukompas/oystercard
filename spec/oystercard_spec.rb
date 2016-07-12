require "oystercard"
describe Oystercard do
  subject(:card){described_class.new}

  context "new card " do
    it "has default balance zero" do
      expect(card.balance).to eq 0
    end
  end

  context "changing balance" do
    it "tops up balance" do
      expect{card.top_up(5)}.to change{card.balance}.by(5)
    end
    it "raises error if over max. balance" do
      maximum_balance = Oystercard::LIMIT
      card.top_up(maximum_balance)
      message = "card limit #{maximum_balance} exceeded"
      expect{card.top_up(1)}.to raise_error message
    end
    it "deducts fare from balance" do
      card.top_up(10)
      expect{card.deduct(5)}. to change{card.balance}. by(-5)
    end
  end

  context "using card to touch in and out" do
    it "shows if new card is in journey" do
      expect(card).not_to be_in_journey
    end

    describe "when touching in" do
      before (:each) do
        card.top_up(Oystercard::MINIMUM_BALANCE)
        card.touch_in
      end

      it "is in a journey after touch in" do
        expect(card).to be_in_journey
      end

      it "is not in a journey after touch out" do
        card.touch_out
        expect(card).not_to be_in_journey
      end

      it "raises an error if a card with insufficient balance is touched in" do
        card.deduct(1)
        expect{card.touch_in}.to raise_error "Insufficient balance. Minimum £#{Oystercard::MINIMUM_BALANCE} is required"
      end

    end # end describe

  end # end context

end # end describe
