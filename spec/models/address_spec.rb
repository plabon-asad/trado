require 'rails_helper'

describe Address do

    # ActiveRecord relations
    it { expect(subject).to belong_to(:order) }
    it { expect(subject).to belong_to(:addressable) }
    
    # Validations
    it { expect(create(:validation_billing_address)).to validate_presence_of(:first_name) }
    it { expect(create(:validation_billing_address)).to validate_presence_of(:last_name) }
    it { expect(create(:validation_billing_address)).to validate_presence_of(:address) }
    it { expect(create(:validation_delivery_address)).to validate_presence_of(:city) }
    it { expect(create(:validation_delivery_address)).to validate_presence_of(:postcode) }
    it { expect(create(:validation_delivery_address)).to validate_presence_of(:country) }

    describe "When displaying an address" do
        let!(:address) { create(:address, first_name: 'John', last_name: 'Doe') }

        it "should return a contact's full name as a string" do
            expect(address.full_name).to eq 'John Doe'
        end
    end

    describe "When determining if validation should occur" do

        context "if the order status is 'billing'" do
            let(:address) { create(:validation_billing_address) }

            it "should return true" do
                expect(address.shipping_stage?).to eq true
            end
        end

        context "if the order status is 'shipping'" do
            let(:address) { create(:validation_delivery_address) }

            it "should return true" do
                expect(address.shipping_stage?).to eq true
            end
        end

        context "if the order status is not 'billing' or 'shipping'" do
            let(:address) { create(:validation_review_address) }

            it "should return nil" do
                expect(address.shipping_stage?).to eq nil
            end
        end
    end
end