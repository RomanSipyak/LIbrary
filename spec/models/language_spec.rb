require 'rails_helper'

RSpec.describe Language, type: :model do
  context 'Asociating' do
    it { is_expected.to have_many(:books) }
  end
end
