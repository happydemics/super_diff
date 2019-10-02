require "spec_helper"

RSpec.describe "Integration with RSpec's #contain_exactly matcher", type: :integration do
  context "when a few number of values are given" do
    it "produces the correct failure message when used in the positive" do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          expected = ["Einie", "Marty"]
          actual = ["Marty", "Jennifer", "Doc"]
          expect(actual).to contain_exactly(*expected)
        TEST
        program = make_plain_test_program(
          snippet,
          color_enabled: color_enabled,
        )

        expected_output = build_expected_output(
          color_enabled: color_enabled,
          snippet: %|expect(actual).to contain_exactly(*expected)|,
          expectation: proc {
            line do
              plain "Expected "
              green %|["Marty", "Jennifer", "Doc"]|
              plain " to contain exactly "
              red   %|"Einie"|
              plain " and "
              red   %|"Marty"|
              plain "."
            end
          },
          diff: proc {
            plain_line %|  [|
            plain_line %|    "Marty",|
            plain_line %|    "Jennifer",|
            plain_line %|    "Doc",|
            red_line   %|-   "Einie"|
            plain_line %|  ]|
          },
        )

        expect(program).
          to produce_output_when_run(expected_output).
          in_color(color_enabled)
      end
    end

    it "produces the correct failure message when used in the negative" do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          values = ["Einie", "Marty"]
          expect(values).not_to contain_exactly(*values)
        TEST
        program = make_plain_test_program(
          snippet,
          color_enabled: color_enabled,
        )

        expected_output = build_expected_output(
          color_enabled: color_enabled,
          snippet: %|expect(values).not_to contain_exactly(*values)|,
          expectation: proc {
            line do
              plain "Expected "
              green %|["Einie", "Marty"]|
              plain " not to contain exactly "
              red   %|"Einie"|
              plain " and "
              red   %|"Marty"|
              plain "."
            end
          },
        )

        expect(program).
          to produce_output_when_run(expected_output).
          in_color(color_enabled)
      end
    end
  end

  context "when a large number of values are given" do
    context "and they are only simple strings" do
      it "produces the correct failure message when used in the positive" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = [
              "Doc Brown",
              "Marty McFly",
              "Biff Tannen",
              "George McFly",
              "Lorraine McFly"
            ]
            actual = [
              "Marty McFly",
              "Doc Brown",
              "Einie",
              "Lorraine McFly"
            ]
            expect(actual).to contain_exactly(*expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).to contain_exactly(*expected)|,
            expectation: proc {
              line do
                plain "          Expected "
                green %|["Marty McFly", "Doc Brown", "Einie", "Lorraine McFly"]|
              end

              line do
                plain "to contain exactly "
                red %|"Doc Brown"|
                plain ", "
                red %|"Marty McFly"|
                plain ", "
                red %|"Biff Tannen"|
                plain ", "
                red %|"George McFly"|
                plain " and "
                red %|"Lorraine McFly"|
              end
            },
            diff: proc {
              plain_line %|  [|
              plain_line %|    "Marty McFly",|
              plain_line %|    "Doc Brown",|
              plain_line %|    "Einie",|
              plain_line %|    "Lorraine McFly",|
              red_line   %|-   "Biff Tannen",|
              red_line   %|-   "George McFly"|
              plain_line %|  ]|
            },
          )

          expect(program).
            to produce_output_when_run(expected_output).
            in_color(color_enabled)
        end
      end

      it "produces the correct failure message when used in the negative" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            values = [
              "Marty McFly",
              "Doc Brown",
              "Einie",
              "Lorraine McFly"
            ]
            expect(values).not_to contain_exactly(*values)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(values).not_to contain_exactly(*values)|,
            newline_before_expectation: true,
            expectation: proc {
              line do
                plain "              Expected "
                green %|["Marty McFly", "Doc Brown", "Einie", "Lorraine McFly"]|
              end

              line do
                plain "not to contain exactly "
                red %|"Marty McFly"|
                plain ", "
                red %|"Doc Brown"|
                plain ", "
                red %|"Einie"|
                plain " and "
                red %|"Lorraine McFly"|
              end
            },
          )

          expect(program).
            to produce_output_when_run(expected_output).
            in_color(color_enabled)
        end
      end
    end

    context "and some of them are regexen" do
      it "produces the correct failure message when used in the positive" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST
            expected = [
              / Brown$/,
              "Marty McFly",
              "Biff Tannen",
              /Georg McFly/,
              /Lorrain McFly/
            ]
            actual = [
              "Marty McFly",
              "Doc Brown",
              "Einie",
              "Lorraine McFly"
            ]
            expect(actual).to contain_exactly(*expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).to contain_exactly(*expected)|,
            expectation: proc {
              line do
                plain "          Expected "
                green %|["Marty McFly", "Doc Brown", "Einie", "Lorraine McFly"]|
              end

              line do
                plain "to contain exactly "
                red %|/ Brown$/|
                plain ", "
                red %|"Marty McFly"|
                plain ", "
                red %|"Biff Tannen"|
                plain ", "
                red %|/Georg McFly/|
                plain " and "
                red %|/Lorrain McFly/|
              end
            },
            diff: proc {
              plain_line %|  [|
              plain_line %|    "Marty McFly",|
              plain_line %|    "Doc Brown",|
              plain_line %|    "Einie",|
              plain_line %|    "Lorraine McFly",|
              red_line   %|-   "Biff Tannen",|
              red_line   %|-   /Georg McFly/,|
              red_line   %|-   /Lorrain McFly/|
              plain_line %|  ]|
            },
          )

          expect(program).
            to produce_output_when_run(expected_output).
            in_color(color_enabled)
        end
      end

      it "produces the correct failure message when used in the negative" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST
            values = [
              / Brown$/,
              "Marty McFly",
              "Biff Tannen",
              /Georg McFly/,
              /Lorrain McFly/
            ]
            expect(values).not_to contain_exactly(*values)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(values).not_to contain_exactly(*values)|,
            newline_before_expectation: true,
            expectation: proc {
              line do
                plain "              Expected "
                green %|[/ Brown$/, "Marty McFly", "Biff Tannen", /Georg McFly/, /Lorrain McFly/]|
              end

              line do
                plain "not to contain exactly "
                red %|/ Brown$/|
                plain ", "
                red %|"Marty McFly"|
                plain ", "
                red %|"Biff Tannen"|
                plain ", "
                red %|/Georg McFly/|
                plain " and "
                red %|/Lorrain McFly/|
              end
            },
          )

          expect(program).
            to produce_output_when_run(expected_output).
            in_color(color_enabled)
        end
      end
    end

    context "and some of them are fuzzy objects" do
      it "produces the correct failure message" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = [
              a_hash_including(foo: "bar"),
              a_collection_containing_exactly("zing"),
              an_object_having_attributes(baz: "qux"),
            ]
            actual = [
              { foo: "bar" },
              double(baz: "qux"),
              { blargh: "riddle" }
            ]
            expect(actual).to contain_exactly(*expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).to contain_exactly(*expected)|,
            expectation: proc {
              line do
                plain "          Expected "
                green %|[{ foo: "bar" }, #<Double (anonymous)>, { blargh: "riddle" }]|
              end

              line do
                plain "to contain exactly "
                red %|#<a hash including (foo: "bar")>|
                plain ", "
                red %|#<a collection containing exactly ("zing")>|
                plain " and "
                red %|#<an object having attributes (baz: "qux")>|
              end
            },
            diff: proc {
              plain_line %|  [|
              plain_line %|    {|
              plain_line %|      foo: "bar"|
              plain_line %|    },|
              plain_line %|    #<Double (anonymous)>,|
              plain_line %|    {|
              plain_line %|      blargh: "riddle"|
              plain_line %|    },|
              red_line   %|-   #<a collection containing exactly (|
              red_line   %|-     "zing"|
              red_line   %|-   )>|
              plain_line %|  ]|
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