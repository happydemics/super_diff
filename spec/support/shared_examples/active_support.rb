shared_examples_for "integration with ActiveSupport" do
  context "when comparing two different Time and ActiveSupport::TimeWithZone instances", active_record: true do
    it "produces the correct failure message when used in the positive" do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~RUBY
          expected = Time.utc(2011, 12, 13, 14, 15, 16)
          actual = Time.utc(2011, 12, 13, 15, 15, 16).in_time_zone("Europe/Stockholm")
          expect(actual).to eq(expected)
        RUBY
        program = make_rspec_rails_test_program(
          snippet,
          color_enabled: color_enabled,
        )

        expected_output = build_expected_output(
          color_enabled: color_enabled,
          snippet: %|expect(actual).to eq(expected)|,
          expectation: proc {
            line do
              plain  %|Expected |
              actual %|2011-12-13 16:15:16.000 CET +01:00 (ActiveSupport::TimeWithZone)|
            end

            line do
              plain    %|   to eq |
              expected %|2011-12-13 14:15:16.000 UTC +00:00 (Time)|
            end
          },
          diff: proc {
            plain_line    %|  #<ActiveSupport::TimeWithZone {|
            plain_line    %|    year: 2011,|
            plain_line    %|    month: 12,|
            plain_line    %|    day: 13,|
            expected_line %|-   hour: 14,|
            actual_line   %|+   hour: 16,|
            plain_line    %|    min: 15,|
            plain_line    %|    sec: 16,|
            plain_line    %|    nsec: 0,|
            expected_line %|-   zone: "UTC",|
            actual_line   %|+   zone: "CET",|
            expected_line %|-   gmt_offset: 0,|
            actual_line   %|+   gmt_offset: 3600,|
            expected_line %|-   utc: 2011-12-13 14:15:16.000 UTC +00:00 (Time)|
            actual_line   %|+   utc: 2011-12-13 15:15:16.000 UTC +00:00 (Time)|
            plain_line    %|  }>|
          },
        )

        expect(program).
          to produce_output_when_run(expected_output).
          in_color(color_enabled)
      end
    end
  end
end
