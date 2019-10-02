require "spec_helper"

RSpec.describe "Integration with RSpec's #match matcher", type: :integration do
  context "when the expected value is a partial hash" do
    context "that is small" do
      it "produces the correct failure message when used in the positive" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = a_hash_including(city: "Hill Valley")
            actual = { city: "Burbank" }
            expect(actual).to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).to match(expected)|,
            expectation: proc {
              line do
                plain "Expected "
                green %|{ city: "Burbank" }|
                plain " to match "
                red %|#<a hash including (city: "Hill Valley")>|
                plain "."
              end
            },
            diff: proc {
              plain_line %|  {|
              red_line   %|-   city: "Hill Valley"|
              green_line %|+   city: "Burbank"|
              plain_line %|  }|
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
            expected = a_hash_including(city: "Burbank")
            actual = { city: "Burbank" }
            expect(actual).not_to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).not_to match(expected)|,
            expectation: proc {
              line do
                plain "Expected "
                green %|{ city: "Burbank" }|
                plain " not to match "
                red %|#<a hash including (city: "Burbank")>|
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

    context "that is large" do
      it "produces the correct failure message when used in the positive" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = a_hash_including(
              city: "Hill Valley",
              zip: "90382"
            )
            actual = {
              line_1: "123 Main St.",
              city: "Burbank",
              state: "CA",
              zip: "90210"
            }
            expect(actual).to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).to match(expected)|,
            expectation: proc {
              line do
                plain "Expected "
                green %|{ line_1: "123 Main St.", city: "Burbank", state: "CA", zip: "90210" }|
              end

              line do
                plain "to match "
                red %|#<a hash including (city: "Hill Valley", zip: "90382")>|
              end
            },
            diff: proc {
              plain_line %|  {|
              plain_line %|    line_1: "123 Main St.",|
              red_line   %|-   city: "Hill Valley",|
              green_line %|+   city: "Burbank",|
              plain_line %|    state: "CA",|
              red_line   %|-   zip: "90382"|
              green_line %|+   zip: "90210"|
              plain_line %|  }|
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
            expected = a_hash_including(
              city: "Burbank",
              zip: "90210"
            )
            actual = {
              line_1: "123 Main St.",
              city: "Burbank",
              state: "CA",
              zip: "90210"
            }
            expect(actual).not_to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).not_to match(expected)|,
            newline_before_expectation: true,
            expectation: proc {
              line do
                plain "    Expected "
                green %|{ line_1: "123 Main St.", city: "Burbank", state: "CA", zip: "90210" }|
              end

              line do
                plain "not to match "
                red %|#<a hash including (city: "Burbank", zip: "90210")>|
              end
            },
          )

          expect(program).
            to produce_output_when_run(expected_output).
            in_color(color_enabled)
        end
      end
    end
  end

  context "when the expected value includes a partial hash" do
    context "and the corresponding actual value is a hash" do
      it "produces the correct failure message when used in the positive" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = {
              name: "Marty McFly",
              address: a_hash_including(
                city: "Hill Valley",
                zip: "90382"
              )
            }
            actual = {
              name: "Marty McFly",
              address: {
                line_1: "123 Main St.",
                city: "Burbank",
                state: "CA",
                zip: "90210"
              }
            }
            expect(actual).to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).to match(expected)|,
            expectation: proc {
              line do
                plain "Expected "
                green %|{ name: "Marty McFly", address: { line_1: "123 Main St.", city: "Burbank", state: "CA", zip: "90210" } }|
              end

              line do
                plain "to match "
                red   %|{ name: "Marty McFly", address: #<a hash including (city: "Hill Valley", zip: "90382")> }|
              end
            },
            diff: proc {
              plain_line %|  {|
              plain_line %|    name: "Marty McFly",|
              plain_line %|    address: {|
              plain_line %|      line_1: "123 Main St.",|
              red_line   %|-     city: "Hill Valley",|
              green_line %|+     city: "Burbank",|
              plain_line %|      state: "CA",|
              red_line   %|-     zip: "90382"|
              green_line %|+     zip: "90210"|
              plain_line %|    }|
              plain_line %|  }|
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
            expected = {
              name: "Marty McFly",
              address: a_hash_including(
                city: "Burbank",
                zip: "90210"
              )
            }
            actual = {
              name: "Marty McFly",
              address: {
                line_1: "123 Main St.",
                city: "Burbank",
                state: "CA",
                zip: "90210"
              }
            }
            expect(actual).not_to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).not_to match(expected)|,
            newline_before_expectation: true,
            expectation: proc {
              line do
                plain "    Expected "
                green %|{ name: "Marty McFly", address: { line_1: "123 Main St.", city: "Burbank", state: "CA", zip: "90210" } }|
              end

              line do
                plain "not to match "
                red   %|{ name: "Marty McFly", address: #<a hash including (city: "Burbank", zip: "90210")> }|
              end
            },
          )

          expect(program).
            to produce_output_when_run(expected_output).
            in_color(color_enabled)
        end
      end
    end

    context "and the corresponding actual value is not a hash" do
      it "produces the correct failure message" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = {
              name: "Marty McFly",
              address: a_hash_including(
                city: "Hill Valley",
                zip: "90382"
              )
            }
            actual = {
              name: "Marty McFly",
              address: nil
            }
            expect(actual).to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).to match(expected)|,
            expectation: proc {
              line do
                plain "Expected "
                green %|{ name: "Marty McFly", address: nil }|
              end

              line do
                plain "to match "
                red   %|{ name: "Marty McFly", address: #<a hash including (city: "Hill Valley", zip: "90382")> }|
              end
            },
            diff: proc {
              plain_line %!  {!
              plain_line %!    name: "Marty McFly",!
              red_line   %!-   address: #<a hash including (!
              red_line   %!-     city: "Hill Valley",!
              red_line   %!-     zip: "90382"!
              red_line   %!-   )>!
              green_line %!+   address: nil!
              plain_line %!  }!
            },
          )

          expect(program).
            to produce_output_when_run(expected_output).
            in_color(color_enabled)
        end
      end
    end
  end

  context "when the expected value is a partial array" do
    context "that is small" do
      it "produces the correct failure message when used in the positive" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = a_collection_including("a")
            actual = ["b"]
            expect(actual).to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).to match(expected)|,
            expectation: proc {
              line do
                plain "Expected "
                green %|["b"]|
                plain " to match "
                red   %|#<a collection including ("a")>|
                plain "."
              end
            },
            diff: proc {
              plain_line %|  [|
              plain_line %|    "b"|
              # red_line   %|-   "a",|   # FIXME
              red_line   %|-   "a"|
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
            expected = a_collection_including("b")
            actual = ["b"]
            expect(actual).not_to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).not_to match(expected)|,
            expectation: proc {
              line do
                plain "Expected "
                green %|["b"]|
                plain " not to match "
                red   %|#<a collection including ("b")>|
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

    context "that is large" do
      it "produces the correct failure message when used in the positive" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = a_collection_including("milk", "bread")
            actual = ["milk", "toast", "eggs", "cheese", "English muffins"]
            expect(actual).to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).to match(expected)|,
            expectation: proc {
              line do
                plain "Expected "
                green %|["milk", "toast", "eggs", "cheese", "English muffins"]|
              end

              line do
                plain "to match "
                red   %|#<a collection including ("milk", "bread")>|
              end
            },
            diff: proc {
              plain_line %|  [|
              plain_line %|    "milk",|
              plain_line %|    "toast",|
              plain_line %|    "eggs",|
              plain_line %|    "cheese",|
              # plain_line %|    "English muffins",|  # FIXME
              plain_line %|    "English muffins"|
              red_line   %|-   "bread"|
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
            expected = a_collection_including("milk", "toast")
            actual = ["milk", "toast", "eggs", "cheese", "English muffins"]
            expect(actual).not_to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).not_to match(expected)|,
            newline_before_expectation: true,
            expectation: proc {
              line do
                plain "    Expected "
                green %|["milk", "toast", "eggs", "cheese", "English muffins"]|
              end

              line do
                plain "not to match "
                red   %|#<a collection including ("milk", "toast")>|
              end
            },
          )

          expect(program).
            to produce_output_when_run(expected_output).
            in_color(color_enabled)
        end
      end
    end
  end

  context "when the expected value includes a partial array" do
    context "and the corresponding actual value is an array" do
      it "produces the correct failure message when used in the positive" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = {
              name: "shopping list",
              contents: a_collection_including("milk", "bread")
            }
            actual = {
              name: "shopping list",
              contents: ["milk", "toast", "eggs"]
            }
            expect(actual).to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).to match(expected)|,
            expectation: proc {
              line do
                plain "Expected "
                green %|{ name: "shopping list", contents: ["milk", "toast", "eggs"] }|
              end

              line do
                plain "to match "
                red   %|{ name: "shopping list", contents: #<a collection including ("milk", "bread")> }|
              end
            },
            diff: proc {
              plain_line %|  {|
              plain_line %|    name: "shopping list",|
              plain_line %|    contents: [|
              plain_line %|      "milk",|
              plain_line %|      "toast",|
              # plain_line %|      "eggs",|     # FIXME
              plain_line %|      "eggs"|
              red_line   %|-     "bread"|
              plain_line %|    ]|
              plain_line %|  }|
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
            expected = {
              name: "shopping list",
              contents: a_collection_including("milk", "toast")
            }
            actual = {
              name: "shopping list",
              contents: ["milk", "toast", "eggs"]
            }
            expect(actual).not_to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).not_to match(expected)|,
            newline_before_expectation: true,
            expectation: proc {
              line do
                plain "    Expected "
                green %|{ name: "shopping list", contents: ["milk", "toast", "eggs"] }|
              end

              line do
                plain "not to match "
                red   %|{ name: "shopping list", contents: #<a collection including ("milk", "toast")> }|
              end
            },
          )

          expect(program).
            to produce_output_when_run(expected_output).
            in_color(color_enabled)
        end
      end
    end

    context "when the corresponding actual value is not an array" do
      it "produces the correct failure message" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = {
              name: "shopping list",
              contents: a_collection_including("milk", "bread")
            }
            actual = {
              name: "shopping list",
              contents: nil
            }
            expect(actual).to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).to match(expected)|,
            expectation: proc {
              line do
                plain "Expected "
                green %|{ name: "shopping list", contents: nil }|
              end

              line do
                plain "to match "
                red   %|{ name: "shopping list", contents: #<a collection including ("milk", "bread")> }|
              end
            },
            diff: proc {
              plain_line %!  {!
              plain_line %!    name: "shopping list",!
              red_line   %!-   contents: #<a collection including (!
              red_line   %!-     "milk",!
              red_line   %!-     "bread"!
              red_line   %!-   )>!
              green_line %!+   contents: nil!
              plain_line %!  }!
            },
          )

          expect(program).
            to produce_output_when_run(expected_output).
            in_color(color_enabled)
        end
      end
    end
  end

  context "when the expected value is a partial object" do
    context "that is small" do
      it "produces the correct failure message when used in the positive" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = an_object_having_attributes(name: "b")
            actual = A.new("a")
            expect(actual).to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).to match(expected)|,
            expectation: proc {
              line do
                plain "Expected "
                green %|#<A name: "a">|
                plain " to match "
                red   %|#<an object having attributes (name: "b")>|
                plain "."
              end
            },
            diff: proc {
              plain_line %|  #<A {|
              # red_line   %|-   name: "b",|  # FIXME
              red_line   %|-   name: "b"|
              green_line %|+   name: "a"|
              plain_line %|  }>|
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
            expected = an_object_having_attributes(name: "b")
            actual = A.new("b")
            expect(actual).not_to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).not_to match(expected)|,
            expectation: proc {
              line do
                plain "Expected "
                green %|#<A name: "b">|
                plain " not to match "
                red   %|#<an object having attributes (name: "b")>|
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

    context "that is large" do
      it "produces the correct failure message when used in the positive" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = an_object_having_attributes(
              line_1: "123 Main St.",
              city: "Oakland",
              zip: "91234",
              state: "CA",
              something_else: "blah"
            )
            actual = SuperDiff::Test::ShippingAddress.new(
              line_1: "456 Ponderosa Ct.",
              line_2: nil,
              city: "Hill Valley",
              state: "CA",
              zip: "90382"
            )
            expect(actual).to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).to match(expected)|,
            expectation: proc {
              line do
                plain "Expected "
                green %|#<SuperDiff::Test::ShippingAddress line_1: "456 Ponderosa Ct.", line_2: nil, city: "Hill Valley", state: "CA", zip: "90382">|
              end

              line do
                plain "to match "
                red   %|#<an object having attributes (line_1: "123 Main St.", city: "Oakland", zip: "91234", state: "CA", something_else: "blah")>|
              end
            },
            diff: proc {
              plain_line %|  #<SuperDiff::Test::ShippingAddress {|
              red_line   %|-   line_1: "123 Main St.",|
              green_line %|+   line_1: "456 Ponderosa Ct.",|
              plain_line %|    line_2: nil,|
              red_line   %|-   city: "Oakland",|
              green_line %|+   city: "Hill Valley",|
              plain_line %|    state: "CA",|
              # red_line   %|-   zip: "91234",|  # FIXME
              # green_line %|+   zip: "90382",|  # FIXME
              red_line   %|-   zip: "91234"|
              green_line %|+   zip: "90382"|
              red_line   %|-   something_else: "blah"|
              plain_line %|  }>|
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
            expected = an_object_having_attributes(
              line_1: "123 Main St.",
              city: "Oakland",
              zip: "91234"
            )
            actual = SuperDiff::Test::ShippingAddress.new(
              line_1: "123 Main St.",
              line_2: nil,
              city: "Oakland",
              zip: "91234",
              state: "CA"
            )
            expect(actual).not_to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).not_to match(expected)|,
            newline_before_expectation: true,
            expectation: proc {
              line do
                plain "    Expected "
                green %|#<SuperDiff::Test::ShippingAddress line_1: "123 Main St.", line_2: nil, city: "Oakland", state: "CA", zip: "91234">|
              end

              line do
                plain "not to match "
                red   %|#<an object having attributes (line_1: "123 Main St.", city: "Oakland", zip: "91234")>|
              end
            },
          )

          expect(program).
            to produce_output_when_run(expected_output).
            in_color(color_enabled)
        end
      end
    end
  end

  context "when the expected value includes a partial object" do
    it "produces the correct failure message when used in the positive" do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          expected = {
            name: "Marty McFly",
            shipping_address: an_object_having_attributes(
              line_1: "123 Main St.",
              city: "Oakland",
              state: "CA",
              zip: "91234",
              something_else: "blah"
            )
          }
          actual = {
            name: "Marty McFly",
            shipping_address: SuperDiff::Test::ShippingAddress.new(
              line_1: "456 Ponderosa Ct.",
              line_2: nil,
              city: "Hill Valley",
              state: "CA",
              zip: "90382"
            )
          }
          expect(actual).to match(expected)
        TEST
        program = make_plain_test_program(
          snippet,
          color_enabled: color_enabled,
        )

        expected_output = build_expected_output(
          color_enabled: color_enabled,
          snippet: %|expect(actual).to match(expected)|,
          expectation: proc {
            line do
              plain "Expected "
              green %|{ name: "Marty McFly", shipping_address: #<SuperDiff::Test::ShippingAddress line_1: "456 Ponderosa Ct.", line_2: nil, city: "Hill Valley", state: "CA", zip: "90382"> }|
            end

            line do
              plain "to match "
              red   %|{ name: "Marty McFly", shipping_address: #<an object having attributes (line_1: "123 Main St.", city: "Oakland", state: "CA", zip: "91234", something_else: "blah")> }|
            end
          },
          diff: proc {
            plain_line %|  {|
            plain_line %|    name: "Marty McFly",|
            plain_line %|    shipping_address: #<SuperDiff::Test::ShippingAddress {|
            red_line   %|-     line_1: "123 Main St.",|
            green_line %|+     line_1: "456 Ponderosa Ct.",|
            plain_line %|      line_2: nil,|
            red_line   %|-     city: "Oakland",|
            green_line %|+     city: "Hill Valley",|
            plain_line %|      state: "CA",|
            # red_line   %|-     zip: "91234",|  # FIXME
            red_line   %|-     zip: "91234"|
            green_line %|+     zip: "90382"|
            red_line   %|-     something_else: "blah"|
            plain_line %|    }>|
            plain_line %|  }|
          },
        )

        expect(program).
          to produce_output_when_run(expected_output).
          in_color(color_enabled)
      end
    end

    it "produces the correct failure message when used the negative" do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          expected = {
            name: "Marty McFly",
            shipping_address: an_object_having_attributes(
              line_1: "123 Main St.",
              city: "Oakland",
              state: "CA",
              zip: "91234"
            )
          }
          actual = {
            name: "Marty McFly",
            shipping_address: SuperDiff::Test::ShippingAddress.new(
              line_1: "123 Main St.",
              line_2: nil,
              city: "Oakland",
              state: "CA",
              zip: "91234",
            )
          }
          expect(actual).not_to match(expected)
        TEST
        program = make_plain_test_program(
          snippet,
          color_enabled: color_enabled,
        )

        expected_output = build_expected_output(
          color_enabled: color_enabled,
          snippet: %|expect(actual).not_to match(expected)|,
          newline_before_expectation: true,
          expectation: proc {
            line do
              plain "    Expected "
              green %|{ name: "Marty McFly", shipping_address: #<SuperDiff::Test::ShippingAddress line_1: "123 Main St.", line_2: nil, city: "Oakland", state: "CA", zip: "91234"> }|
            end

            line do
              plain "not to match "
              red   %|{ name: "Marty McFly", shipping_address: #<an object having attributes (line_1: "123 Main St.", city: "Oakland", state: "CA", zip: "91234")> }|
            end
          },
        )

        expect(program).
          to produce_output_when_run(expected_output).
          in_color(color_enabled)
      end
    end
  end

  context "when the expected value is an order-independent array" do
    context "that is small" do
      it "produces the correct failure message when used in the positive" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = a_collection_containing_exactly("a")
            actual = ["b"]
            expect(actual).to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).to match(expected)|,
            expectation: proc {
              line do
                plain "Expected "
                green %|["b"]|
                plain " to match "
                red   %|#<a collection containing exactly ("a")>|
                plain "."
              end
            },
            diff: proc {
              plain_line %|  [|
              plain_line %|    "b",|
              red_line   %|-   "a"|
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
            expected = a_collection_containing_exactly("b")
            actual = ["b"]
            expect(actual).not_to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).not_to match(expected)|,
            expectation: proc {
              line do
                plain "Expected "
                green %|["b"]|
                plain " not to match "
                red   %|#<a collection containing exactly ("b")>|
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

    context "that is large" do
      it "produces the correct failure message when used in the positive" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = a_collection_containing_exactly("milk", "bread")
            actual = ["milk", "toast", "eggs", "cheese", "English muffins"]
            expect(actual).to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).to match(expected)|,
            expectation: proc {
              line do
                plain "Expected "
                green %|["milk", "toast", "eggs", "cheese", "English muffins"]|
              end

              line do
                plain "to match "
                red   %|#<a collection containing exactly ("milk", "bread")>|
              end
            },
            diff: proc {
              plain_line %|  [|
              plain_line %|    "milk",|
              plain_line %|    "toast",|
              plain_line %|    "eggs",|
              plain_line %|    "cheese",|
              plain_line %|    "English muffins",|
              red_line   %|-   "bread"|
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
            expected = a_collection_containing_exactly("milk", "eggs", "toast")
            actual = ["milk", "toast", "eggs"]
            expect(actual).not_to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).not_to match(expected)|,
            newline_before_expectation: true,
            expectation: proc {
              line do
                plain "    Expected "
                green %|["milk", "toast", "eggs"]|
              end

              line do
                plain "not to match "
                red   %|#<a collection containing exactly ("milk", "eggs", "toast")>|
              end
            },
          )

          expect(program).
            to produce_output_when_run(expected_output).
            in_color(color_enabled)
        end
      end
    end
  end

  context "when the expected value includes an order-independent array" do
    context "and the corresponding actual value is an array" do
      it "produces the correct failure message when used in the positive" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = {
              name: "shopping list",
              contents: a_collection_containing_exactly("milk", "bread")
            }
            actual = {
              name: "shopping list",
              contents: ["milk", "toast", "eggs"]
            }
            expect(actual).to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).to match(expected)|,
            expectation: proc {
              line do
                plain "Expected "
                green %|{ name: "shopping list", contents: ["milk", "toast", "eggs"] }|
              end

              line do
                plain "to match "
                red   %|{ name: "shopping list", contents: #<a collection containing exactly ("milk", "bread")> }|
              end
            },
            diff: proc {
              plain_line %|  {|
              plain_line %|    name: "shopping list",|
              plain_line %|    contents: [|
              plain_line %|      "milk",|
              plain_line %|      "toast",|
              plain_line %|      "eggs",|
              red_line   %|-     "bread"|
              plain_line %|    ]|
              plain_line %|  }|
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
            expected = {
              name: "shopping list",
              contents: a_collection_containing_exactly("milk", "eggs", "toast")
            }
            actual = {
              name: "shopping list",
              contents: ["milk", "toast", "eggs"]
            }
            expect(actual).not_to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).not_to match(expected)|,
            newline_before_expectation: true,
            expectation: proc {
              line do
                plain "    Expected "
                green %|{ name: "shopping list", contents: ["milk", "toast", "eggs"] }|
              end

              line do
                plain "not to match "
                red   %|{ name: "shopping list", contents: #<a collection containing exactly ("milk", "eggs", "toast")> }|
              end
            },
          )

          expect(program).
            to produce_output_when_run(expected_output).
            in_color(color_enabled)
        end
      end
    end

    context "when the corresponding actual value is not an array" do
      it "produces the correct failure message" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            expected = {
              name: "shopping list",
              contents: a_collection_containing_exactly("milk", "bread")
            }
            actual = {
              name: "shopping list",
              contents: nil
            }
            expect(actual).to match(expected)
          TEST
          program = make_plain_test_program(
            snippet,
            color_enabled: color_enabled,
          )

          expected_output = build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect(actual).to match(expected)|,
            expectation: proc {
              line do
                plain "Expected "
                green %|{ name: "shopping list", contents: nil }|
              end

              line do
                plain "to match "
                red   %|{ name: "shopping list", contents: #<a collection containing exactly ("milk", "bread")> }|
              end
            },
            diff: proc {
              plain_line %!  {!
              plain_line %!    name: "shopping list",!
              red_line   %!-   contents: #<a collection containing exactly (!
              red_line   %!-     "milk",!
              red_line   %!-     "bread"!
              red_line   %!-   )>!
              green_line %!+   contents: nil!
              plain_line %!  }!
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