shared_examples_for "integration with HashWithIndifferentAccess" do
  describe "and RSpec's #eq matcher" do
    context "when the actual value is a HashWithIndifferentAccess" do
      it "produces the correct output" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = {
              line_1: "123 Main St.",
              city: "Hill Valley",
              state: "CA",
              zip: "90382",
            }
            actual = HashWithIndifferentAccess.new({
              line_1: "456 Ponderosa Ct.",
              city: "Oakland",
              state: "CA",
              zip: "91234",
            })
            expect(actual).to eq(expected)
          TEST
          program = make_rspec_rails_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: "expect(actual).to eq(expected)",
            expectation: proc {
              line do
                plain "Expected "
                green %|#<HashWithIndifferentAccess { "line_1" => "456 Ponderosa Ct.", "city" => "Oakland", "state" => "CA", "zip" => "91234" }>|
              end

              line do
                plain "   to eq "
                red   %|{ line_1: "123 Main St.", city: "Hill Valley", state: "CA", zip: "90382" }|
              end
            },
            diff: proc {
              plain_line %|  #<HashWithIndifferentAccess {|
              red_line   %|-   "line_1" => "123 Main St.",|
              green_line %|+   "line_1" => "456 Ponderosa Ct.",|
              red_line   %|-   "city" => "Hill Valley",|
              green_line %|+   "city" => "Oakland",|
              plain_line %|    "state" => "CA",|
              red_line   %|-   "zip" => "90382"|
              green_line %|+   "zip" => "91234"|
              plain_line %|  }>|
            },
          )

          expect(program).
            to produce_output_when_run(expected_output).
            in_color(color_enabled)
        end
      end
    end

    context "when the expected value is a HashWithIndifferentAccess" do
      it "produces the correct output" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = HashWithIndifferentAccess.new({
              line_1: "456 Ponderosa Ct.",
              city: "Oakland",
              state: "CA",
              zip: "91234",
            })
            actual = {
              line_1: "123 Main St.",
              city: "Hill Valley",
              state: "CA",
              zip: "90382",
            }
            expect(actual).to eq(expected)
          TEST
          program = make_rspec_rails_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: "expect(actual).to eq(expected)",
            expectation: proc {
              line do
                plain "Expected "
                green %|{ line_1: "123 Main St.", city: "Hill Valley", state: "CA", zip: "90382" }|
              end

              line do
                plain "   to eq "
                red   %|#<HashWithIndifferentAccess { "line_1" => "456 Ponderosa Ct.", "city" => "Oakland", "state" => "CA", "zip" => "91234" }>|
              end
            },
            diff: proc {
              plain_line %|  #<HashWithIndifferentAccess {|
              red_line   %|-   "line_1" => "456 Ponderosa Ct.",|
              green_line %|+   "line_1" => "123 Main St.",|
              red_line   %|-   "city" => "Oakland",|
              green_line %|+   "city" => "Hill Valley",|
              plain_line %|    "state" => "CA",|
              red_line   %|-   "zip" => "91234"|
              green_line %|+   "zip" => "90382"|
              plain_line %|  }>|
            },
          )

          expect(program).
            to produce_output_when_run(expected_output).
            in_color(color_enabled)
        end
      end
    end
  end

  describe "and RSpec's #match matcher" do
    context "when the actual value is a HashWithIndifferentAccess" do
      it "produces the correct output" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = {
              line_1: "123 Main St.",
              city: "Hill Valley",
              state: "CA",
              zip: "90382",
            }
            actual = HashWithIndifferentAccess.new({
              line_1: "456 Ponderosa Ct.",
              city: "Oakland",
              state: "CA",
              zip: "91234",
            })
            expect(actual).to match(expected)
          TEST
          program = make_rspec_rails_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: "expect(actual).to match(expected)",
            expectation: proc {
              line do
                plain "Expected "
                green %|#<HashWithIndifferentAccess { "line_1" => "456 Ponderosa Ct.", "city" => "Oakland", "state" => "CA", "zip" => "91234" }>|
              end

              line do
                plain "to match "
                red   %|{ line_1: "123 Main St.", city: "Hill Valley", state: "CA", zip: "90382" }|
              end
            },
            diff: proc {
              plain_line %|  #<HashWithIndifferentAccess {|
              red_line   %|-   "line_1" => "123 Main St.",|
              green_line %|+   "line_1" => "456 Ponderosa Ct.",|
              red_line   %|-   "city" => "Hill Valley",|
              green_line %|+   "city" => "Oakland",|
              plain_line %|    "state" => "CA",|
              red_line   %|-   "zip" => "90382"|
              green_line %|+   "zip" => "91234"|
              plain_line %|  }>|
            },
          )

          expect(program).
            to produce_output_when_run(expected_output).
            in_color(color_enabled)
        end
      end
    end

    context "when the expected value is a HashWithIndifferentAccess" do
      it "produces the correct output" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = HashWithIndifferentAccess.new({
              line_1: "456 Ponderosa Ct.",
              city: "Oakland",
              state: "CA",
              zip: "91234",
            })
            actual = {
              line_1: "123 Main St.",
              city: "Hill Valley",
              state: "CA",
              zip: "90382",
            }
            expect(actual).to match(expected)
          TEST
          program = make_rspec_rails_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: "expect(actual).to match(expected)",
            expectation: proc {
              line do
                plain "Expected "
                green %|{ line_1: "123 Main St.", city: "Hill Valley", state: "CA", zip: "90382" }|
              end

              line do
                plain "to match "
                red   %|#<HashWithIndifferentAccess { "line_1" => "456 Ponderosa Ct.", "city" => "Oakland", "state" => "CA", "zip" => "91234" }>|
              end
            },
            diff: proc {
              plain_line %|  #<HashWithIndifferentAccess {|
              red_line   %|-   "line_1" => "456 Ponderosa Ct.",|
              green_line %|+   "line_1" => "123 Main St.",|
              red_line   %|-   "city" => "Oakland",|
              green_line %|+   "city" => "Hill Valley",|
              plain_line %|    "state" => "CA",|
              red_line   %|-   "zip" => "91234"|
              green_line %|+   "zip" => "90382"|
              plain_line %|  }>|
            },
          )

          expect(program).
            to produce_output_when_run(expected_output).
            in_color(color_enabled)
        end
      end
    end
  end
end