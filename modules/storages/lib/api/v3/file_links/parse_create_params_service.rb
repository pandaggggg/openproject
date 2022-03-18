#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2022 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++

module API::V3::FileLinks
  class ParseCreateParamsService < ::API::ParseResourceParamsService
    def call(request_body)
      ServiceResult.new(
        success: true,
        result: parse_elements(request_body)
      )
    end

    def parse_elements(request_body)
      request_body.dig("_embedded", "elements")
                  .tap { ensure_valid_elements(_1) }
                  .map do |params|
        API::V3::FileLinks::FileLinkRepresenter
          .new(Hashie::Mash.new, current_user: current_user)
          .from_hash(params)
      end
    end

    private

    def ensure_valid_elements(elements)
      raise API::Errors::PropertyMissingError.new('_embedded/elements') if elements.blank?
      raise API::Errors::PropertyFormatError.new('_embedded/elements', 'Array', elements.class.name) unless elements.is_a?(Array)
    end
  end
end