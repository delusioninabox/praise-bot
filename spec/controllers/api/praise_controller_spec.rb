RSpec.describe Api::PraiseController, type: :controller do

  describe '#create' do

    context "with trigger_id" do
      let(:params) { { "trigger_id": "1234" } }
      it 'calls to open modal' do
        expect(PraiseModal).to receive(:open).with(params[:trigger_id]).once
        post :create, :params => params
      end
    end

    context "with block_actions" do
      # calls to save action
    end

    context "with view_submission" do
      # calls to view submission
    end

    context "no view_closed" do
      # calls to delete view
    end
  end
end