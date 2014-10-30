# -*- encoding : utf-8 -*-
require 'helpers'

require 'instance_accountant/filer'

module InstanceAccountant
  Class File do
    Instance do
      subject { Filer.new options }

      let(:options) do
        {
          filepath:   filepath,
          file_klass: file_klass,
          time_klass: time_klass
        }
      end

      let(:filepath)          { double 'filepath'          }
      let(:expanded_filepath) { double 'expanded_filepath' }
      let(:file_klass)        { double 'file_klass'        }
      let(:time_klass)        { double 'time_klass'        }
      let(:time_inst)         { double 'time_inst'         }

      let(:time_string)       { double 'time_string' }
      let(:hour)              { double 'hour'        }

      RespondsTo :read do
        When 'it has been written before' do
          ByReturning 'a Time' do
            expect(file_klass)
              .to receive(:expand_path)
              .with(filepath)
              .and_return(expanded_filepath)

            expect(file_klass)
              .to receive(:open)
              .with(expanded_filepath, File::RDWR | File::CREAT, 0644)
              .and_return(time_string)

            expect(time_klass)
              .to receive(:parse)
              .with(time_string)
              .and_return(time_inst)

            subject.read.must_be_same_as time_inst
          end
        end
      end

      RespondsTo :write do
        ByReturning 'the hour' do
          expect(file_klass)
            .to receive(:expand_path)
            .with(filepath)
            .and_return(expanded_filepath)

          expect(hour)
            .to receive(:to_s)
            .and_return(time_string)

          expect(file_klass)
            .to receive(:open)
            .with(expanded_filepath, File::RDWR | File::CREAT, 0644)
            .and_return(time_string)

          subject.write(hour).must_be_same_as time_string
        end
      end
    end
  end
end
