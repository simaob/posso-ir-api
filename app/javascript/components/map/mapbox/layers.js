import colors from '../map-view.scss'
export const devBasemapLayer = () => ({
  id: 'dev-basemap',
  type: 'raster',
  source: {
    tileSize: 256,
    tiles: [
      'https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
      'https://b.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
      'https://c.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png'
    ],
    attribution:
      '&copy;<a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, <a href="http://hot.openstreetmap.org/" target="_blank">Humanitarian OpenStreetMap Team</a>'
  }
});

export const shopsLayer = data => ({
  id: 'shops',
  type: 'geojson',
  source: {
    type: 'geojson',
    promoteId: 'id',
    data,
    cluster: true,
    clusterMaxZoom: 14,
    clusterRadius: 45
  },
  render: {
    metadata: {
      position: 'top'
    },
    layers: [
      {
        id: 'shops-clusters',
        metadata: {
          position: 'top'
        },
        type: 'circle',
        filter: ['has', 'point_count'],
        paint: {
          'circle-color': '#FFF',
          'circle-stroke-width': 2,
          'circle-stroke-color': '#5ca2d1',
          'circle-radius': 12
        }
      },
      {
        id: 'shops-cluster-count',
        metadata: {
          position: 'top'
        },
        type: 'symbol',
        filter: ['has', 'point_count'],
        layout: {
          'text-allow-overlap': true,
          'text-ignore-placement': true,
          'text-field': '{point_count_abbreviated}',
          'text-size': 12
        }
      },
      {
        id: 'shops',
        metadata: {
          position: 'top'
        },
        type: 'circle',
        filter: ['!', ['has', 'point_count']],
        paint: {
          'circle-color': [
            'match',
            ['get', 'state'],
            'live', colors['shop-state-live'],
            'waiting_approval', colors['shop-state-waiting-approval'],
            'marked_for_deletion', colors['shop-state-marked-for-deletion'],
            colors['shop-state-unknown']
          ],
          'circle-stroke-width': 2,
          'circle-stroke-color': '#fff',
          'circle-radius': 8
        }
      }
    ]
  }
});
