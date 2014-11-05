# -*- encoding : utf-8 -*-
require 'helpers'

require 'instance_accountant/filer'

module InstanceAccountant
  Class Filer do
    Instance do
      subject { Filer.new options }

      let(:options) do
        {
          file_klass: file_klass,
          time_klass: time_klass,
          filepath:   filepath
        }
      end

      let(:filepath)          { double 'filepath'          }
      let(:expanded_filepath) { double 'expanded_filepath' }
      let(:file_klass)        { double 'file_klass'        }
      let(:time_klass)        { double 'time_klass'        }
      let(:time_inst)         { double 'time_inst'         }

      let(:hour_string)       { double 'hour_string' }
      let(:hour)              { double 'hour'        }

      let(:file) { double 'file' }

      RespondsTo :read do
        When 'it has not been written before' do
          ByReturning nil do
            expect(file_klass)
              .to receive(:expand_path)
              .with(filepath)
              .and_return(expanded_filepath)

            expect(file_klass)
              .to receive(:open)
              .with(expanded_filepath, 'r')
              .and_raise(Errno::ENOENT)

            subject.read.must_be_nil
          end
        end

        When 'it has been written before' do
          ByReturning 'a Time' do
            expect(file_klass)
              .to receive(:expand_path)
              .with(filepath)
              .and_return(expanded_filepath)

            expect(file_klass)
              .to receive(:open)
              .with(expanded_filepath, 'r')
              .and_yield(file)

            expect(file)
              .to receive(:flock)
              .with(File::LOCK_EX)

            expect(file)
              .to receive(:read)
              .and_return(hour_string)

            expect(time_klass)
              .to receive(:parse)
              .with(hour_string)
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
            .to receive(:hour_string)
            .and_return(hour_string)

          expect(file_klass)
            .to receive(:open)
            .with(expanded_filepath, File::RDWR | File::CREAT, 0644)
            .and_yield(file)

          expect(file)
            .to receive(:flock)
            .with(File::LOCK_EX)

          expect(file)
            .to receive(:truncate)
            .with(0)

          expect(file)
            .to receive(:write)
            .with(hour_string)

          subject.write(hour).must_be_same_as hour_string
        end
      end
    end
  end
end
