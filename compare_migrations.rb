#!/usr/bin/env ruby

require 'fileutils'
require 'json'

puts "=== Migration Analysis for Decision Trees/Nodes ==="
puts

# List all migrations related to decision_trees and decision_nodes
decision_migrations = [
  '20250611162916_create_decision_trees.rb',
  '20250611162952_create_decision_nodes.rb', 
  '20250611163025_create_node_votes.rb',
  '20250620073514_add_child_type_to_decision_nodes.rb',
  '20250627000000_add_missing_columns_to_decision_nodes.rb'
]

puts "Decision-related migrations found:"
decision_migrations.each do |migration|
  puts "  - #{migration}"
end
puts

# Expected final schema for decision_nodes table
expected_columns = [
  'id (bigint, primary key)',
  'content (text)',
  'position (integer)',
  'decision_tree_id (bigint, indexed)',
  'user_id (bigint, indexed)',
  'parent_id (bigint, indexed)',
  'created_at (datetime)',
  'updated_at (datetime)',
  'url (string)',
  'url_confirmed (boolean, default: false, null: false)',
  'child_type (integer)'
]

puts "Expected decision_nodes table structure:"
expected_columns.each do |column|
  puts "  - #{column}"
end
puts

# Migration timeline analysis
puts "=== Migration Timeline Analysis ==="
puts "1. 20250611162916_create_decision_trees.rb - Creates decision_trees table"
puts "2. 20250611162952_create_decision_nodes.rb - Creates decision_nodes table with:"
puts "   - content (text)"
puts "   - parent_id (foreign key to decision_nodes)"
puts "   - decision_tree_id (foreign key to decision_trees)"
puts "   - timestamps"
puts "3. 20250611163025_create_node_votes.rb - Creates node_votes table"
puts "4. 20250620073514_add_child_type_to_decision_nodes.rb - Adds child_type column"
puts "5. 20250627000000_add_missing_columns_to_decision_nodes.rb - Adds missing columns:"
puts "   - user_id (bigint)"
puts "   - position (integer)"
puts "   - url (string)"
puts "   - url_confirmed (boolean, default: false, null: false)"
puts "   - Adds index on user_id"
puts

puts "=== Potential Issues ==="
puts "1. The original create_decision_nodes migration (20250611162952) only created:"
puts "   - content, parent_id, decision_tree_id, timestamps"
puts "2. Missing columns were added later in 20250627000000:"
puts "   - user_id, position, url, url_confirmed"
puts "3. child_type was added in 20250620073514"
puts
puts "If production is missing the 20250627000000 migration, it would be missing:"
puts "  - user_id column and index"
puts "  - position column"
puts "  - url column"
puts "  - url_confirmed column"
puts
puts "This would explain why the tables are different between environments."
puts
puts "=== Recommended Actions ==="
puts "1. Check if migration 20250627000000_add_missing_columns_to_decision_nodes.rb"
puts "   was run on production"
puts "2. Check if migration 20250620073514_add_child_type_to_decision_nodes.rb"
puts "   was run on production"
puts "3. Run the missing migrations on production if needed"
puts "4. Verify the schema matches between environments" 