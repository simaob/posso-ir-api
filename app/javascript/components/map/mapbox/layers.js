const colors = {
  shopStateLive: '#41c14f',
  shopStateWaitingApproval: '#ffcc00',
  shopStateMarkedForDeletion: '#979797',
  shopStateUnknown: '#5ca2d1',
  white: '#fff'
};

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

export const shopsLayer = (data, selectedId) => ({
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
          'circle-color': colors.white,
          'circle-stroke-width': 2,
          'circle-stroke-color': colors.shopStateUnknown,
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
        filter: [
          'all',
          ['!', ['has', 'point_count']],
          [
            'case',
            ['to-boolean', selectedId],
            [
              'case',
              ['has', 'temporaryId'],
              ['!=', ['get', 'temporaryId'], selectedId],
              ['!=', ['get', 'id'], selectedId]
            ],
            true
          ]
        ],
        paint: {
          'circle-color': [
            'match',
            ['get', 'state'],
            'live',
            colors.shopStateLive,
            'waiting_approval',
            colors.shopStateWaitingApproval,
            'marked_for_deletion',
            colors.shopStateMarkedForDeletion,
            colors.shopStateUnknown
          ],
          'circle-stroke-width': 2,
          'circle-stroke-color': colors.white,
          'circle-radius': 8
        }
      }
    ]
  }
});
