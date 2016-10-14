describe Sprat::Job do

  it "should exec job" do

    result = Sprat::Result.new

    api = double(:api)

    test = double(:test)
    expect(test).to receive(:exec).with(api) {result}

    source = double(:source)
    expect(source).to receive(:get_api).with('google.com') {api}
    expect(source).to receive(:tests) {[test]}

    job = Sprat::Job.new(source)
    job.local = true
    job.host = 'google.com'

    job.exec

  end

  it "should set status" do

    result1 = Sprat::Result.new(result: 'PASS')
    result2 = Sprat::Result.new(result: 'FAIL', reason: 'not a good reason')

    job = Sprat::Job.new
    job.set_status([result1, result2])

    expect(job.status).to eql('FAIL (1 errors)')

  end

end