module BxBlockNotifsettings
	class EasyMode < BxBlockNotifsettings::ApplicationRecord
		self.table_name = :easy_modes

		enum nights_ahead: {"declined" => 0, "charged" => 1, "undecided" => 2}

    end
end
