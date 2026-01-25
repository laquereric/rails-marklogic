class CreateMcpTypes < ActiveRecord::Migration[8.1]
  def change
     create_table :mcp_types do |t|
       t.string :uri, null: false
       t.string :name

       if connection.adapter_name.downcase.include?("postgres")
         t.jsonb :schema, null: false
         t.jsonb :context
       else
         t.json  :schema, null: false
         t.json  :context
       end

       t.string :structural_hash, null: false

      t.integer :version, null: false, default: 1
      t.string :environment, null: false
      t.bigint :created_by_policy_id
      t.timestamps
    end

    add_index :mcp_types, :uri, unique: true
    add_index :mcp_types, [ :structural_hash, :version ], unique: true
    add_index :mcp_types, :structural_hash
    add_index :mcp_types, :environment
  end
end
