require 'diff_renderer'

describe RailsDiff::DiffRenderer do
  let(:destination) { 'diff/source/target' }
  let(:source)      { double }

  describe '::from_task' do
    subject           { described_class.from_task(task) }
    let(:task)        { double(name: destination, source: source) }
    let(:template)    { double }

    it { expect(subject.destination).to eq(destination) }
    it { expect(subject.source).to eq(source) }
  end

  describe '#generate' do
    subject          { described_class.new(destination: destination,
                                           file_util: file_util,
                                           source: source) }
    let(:file_util)  { double(read: '', write: nil) }
    let(:renderer)   { double.as_null_object }

    it 'calls renderer with locals' do
      subject.generate template_renderer: renderer
      expect(renderer).to have_received(:call).with(hash_including(:locals))
    end
  end
end
