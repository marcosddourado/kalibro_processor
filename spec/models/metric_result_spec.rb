require 'spec_helper'

describe MetricResult do
  describe "method" do
    describe "initialize" do
      context "with valid attributes" do
        subject { FactoryGirl.build(:metric_result_with_value) }

        it 'should return an instance of MetricResult' do
          subject.should be_a(MetricResult)
        end

        it 'should have the right attributes' do
          subject.value.should eq(2.0)
          subject.error.should be_nil
        end

        it 'should have the average method' do
          subject.descendant_results = []
          subject.descendant_results.should respond_to :average
        end
      end
    end

    describe 'aggregated_value' do
      context 'when value is NaN and the descendant_results array is not empty' do
        subject { FactoryGirl.build(:metric_result) }

        it 'should calculate the average value of the descendant_results array' do
          subject.aggregated_value.should eq(2.0)
        end
      end

      context 'when the metric_results are not from a leaf module' do
        subject { FactoryGirl.build(:metric_result_with_value) }

        it 'should return the value' do
          subject.aggregated_value.should eq(subject.value)
        end
      end
    end

    describe 'range' do
      let!(:range) { FactoryGirl.build(:range) }
      let!(:yet_another_range) { FactoryGirl.build(:yet_another_range) }
      let!(:metric_result) { FactoryGirl.build(:metric_result_with_value) }
      
      before :each do
        KalibroGatekeeperClient::Entities::Range.expects(:ranges_of).
            with(metric_result.metric_configuration.id).returns([range, yet_another_range])
      end

      it 'should return the range that contains the aggregated value of the metric result' do
        metric_result.range.should eq(range)
      end
    end
  end
end
