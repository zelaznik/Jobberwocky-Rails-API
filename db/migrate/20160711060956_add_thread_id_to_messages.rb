class AddThreadIdToMessages < ActiveRecord::Migration
  def up
    execute "DROP TRIGGER IF EXISTS bef_ins_message_set_thread_id ON messages"
    execute "DROP FUNCTION IF EXISTS _bef_ins_message_set_thread_id();"

    execute "
    CREATE FUNCTION _bef_ins_message_set_thread_id() RETURNS trigger AS $$
      BEGIN
        IF NEW.sender_id > NEW.receiver_id THEN
          NEW.thread_id = concat(NEW.receiver_id, '.', NEW.sender_id);
        ELSE
          NEW.thread_id = concat(NEW.sender_id, '.', NEW.receiver_id);
        END IF;

        RETURN NEW;
      END;
    $$ LANGUAGE plpgsql;
    "
    execute "
    CREATE TRIGGER bef_ins_message_set_thread_id BEFORE INSERT OR UPDATE ON messages
    FOR EACH ROW EXECUTE PROCEDURE _bef_ins_message_set_thread_id();
    "
  end

  def down
    execute "DROP TRIGGER IF EXISTS bef_ins_message_set_thread_id ON messages"
    execute "DROP FUNCTION IF EXISTS _bef_ins_message_set_thread_id();"
  end
end
