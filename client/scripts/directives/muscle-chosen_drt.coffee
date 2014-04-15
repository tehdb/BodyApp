angular.module("BodyApp").directive( "muscleChosen", [
	"$q", "$timeout", "$compile", "MusclesService",
	( q, tmt, cpl, m_srv ) ->
		restrict: "E"
		scope: {
			selected : "="
		}
		replace: true
		template: '"{{templates/directives/muscle-chosen.html}}"'

		link : (scp, elm, atr ) ->
			# defaults
			scp.data = {
				available : []
				filtered : null
				searchText : ''
				newMuscleForm : {
					name : ''
					group : m_srv.getGroups()[0]
				}
				muscleGroups : m_srv.getGroups()
				toggles : {
					showMenu : false
					showFilter : false
					showAddForm : false
				}
			}

			# private
			_watchSelected = ->
				scp.$watch( 'selected',  ->
					_setAvailable()
				, true )

			_setAvailable = ->
				selectedIds = _.pluck( scp.selected, '_id')
				scp.data.available = _.filter scp.data.options , (elm) ->
					return not _.contains( selectedIds, elm._id)

			# init
			do ->
				scp.selected = scp.selected || []
				m_srv.getAll().then (data) ->
					scp.data.options = data
					_setAvailable()
					_watchSelected()

			# public
			scp.add = (event) ->
				event.preventDefault()
				event.stopPropagation()

				form = angular.copy( scp.data.newMuscleForm )
				m_srv.upsert( form ).then ( data ) ->
					scp.data.available.push( data )
					scp.data.newMuscleForm.name = ''


			scp.toggleMenu = (event) ->
				event.preventDefault()
				event.stopPropagation()
				scp.data.searchText = ""
				scp.data.toggles.showMenu = !scp.data.toggles.showMenu

			scp.toggleFilter = (event) ->
				event.preventDefault()
				event.stopPropagation()
				scp.data.toggles.showFilter = !scp.data.toggles.showFilter


			scp.toggleAddForm = (event) ->
				event.preventDefault()
				event.stopPropagation()
				scp.data.toggles.showAddForm =  !scp.data.toggles.showAddForm


			scp.unselect = (index, event ) ->
				event.preventDefault()
				event.stopPropagation()
				scp.selected.splice( index, 1)


			scp.select = (index, event) ->
				event.preventDefault()
				event.stopPropagation()
				scp.selected.push( scp.data.filtered[index] )
				scp.data.toggles.showMenu = false


			scp.prevent = (event) ->
				event.preventDefault()
				event.stopPropagation()


			scp.clear = (event) ->
				event.preventDefault()
				event.stopPropagation()
				scp.data.searchText = ""
])
