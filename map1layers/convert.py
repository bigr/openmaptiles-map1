import yaml
import glob
import os
from collections import OrderedDict
try:
    from yaml import CLoader as Loader, CDumper as Dumper
except ImportError:
    from yaml import Loader, Dumper

def setup_yaml():
  """ https://stackoverflow.com/a/8661021 """
  represent_dict_order = lambda self, data:  self.represent_mapping('tag:yaml.org,2002:map', data.items())
  yaml.add_representer(OrderedDict, represent_dict_order)

setup_yaml()

layers = []

for lname in glob.glob('*'):

    if lname in {'.', '..'}:
        continue

    if not os.path.isdir(lname):
        continue

    print(lname)

    layers.append(lname)

    fields = OrderedDict()

    with open("{}/mapping.yaml".format(lname), 'rt') as f:
        content = f.read()

    mapping = yaml.load(content, Loader=Loader)

    fields = {field['name']: {
            'description': field['name'] if not 'key' in field else field['key']
        } for field in mapping['tables'][lname]['fields']
    }

    with open("{}/{}.sql".format(lname, lname), 'wt') as f:
        pass

    with open("{}/{}.yaml".format(lname, lname), 'wt') as f:
        yaml.dump(OrderedDict([
            ('layers', OrderedDict([
                ('id', lname),
                ('buffer_size', 20),
                ('fields', fields),
                ('datasource', OrderedDict([
                    ('geometry_field', 'way'),
                    ('query', '(SELECT FROM ) AS t')
                ]))])),
            ('schema', ['{}.sql'.format(lname)]),
            ('datasources', [OrderedDict([
                ('type', 'imposm3'),
                ('mapping_file', './mapping.yaml')
            ])])
        ]), f)


with open("openmaptiles.yaml", 'wt') as f:
    yaml.dump({'tileset': OrderedDict([
        ('layers', ["layers/{}/{}.yaml".format(l, l) for l in layers]),
        ('name', 'map1eu'),
        ('version', '0.2.0'),
        ('id', 'map1eu'),
        ('description', 'A tileset showcasing all layers in Map1eu. https://map1.eu'),
        ('attribution', '<a href="https://www.openmaptiles.org/" target="_blank">&copy; OpenMapTiles</a> <a href="https://www.openstreetmap.org/copyright" target="_blank">&copy; OpenStreetMap contributors</a'),
        ('center', [14.4, 50.1, 8]),
        ('bounds', [14.265088,50.082495,14.539746,50.268949]),
        ('maxzoom', 14),
        ('minzoom', 0),
        ('pixel_scale', 256),
        ('languages', ['en']),
        ('defaults', OrderedDict([
            ('srs', '+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0.0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs +over'),
            ('datasource', {'srid': '900913'})
        ]))
    ])}, f)