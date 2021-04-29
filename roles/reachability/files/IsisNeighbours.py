from pyats import aetest
from genie import parsergen


class common_setup(aetest.CommonSetup):

    @aetest.subsection
    def connect(self, testbed):

        self.parent.parameters['testbed'] = testbed
        device_list = []
        for device in testbed:
            try:
                device.connect(prompt_recovery=True)
            except Exception as e:
                self.failed("Failed to establish connection to '{0}'".format(device.name))
            device_list.append(device)
        self.parent.parameters.update(dev=device_list)


class IsisNeighbours(aetest.Testcase):

    @aetest.test
    def learn_l2_isis_neighbours_amount(self):

        self.parent.parameters['isis_neighbours'] = {}
        for device in self.parent.parameters['dev']:
               table_dict = parsergen.oper_fill_tabular(device=device,
                                                         show_command="show isis neighbors summary",
                                                         header_fields=["State", "L1", "L2", "L1L2"],
                                                         index=[0, 3],
                                                         device_os="iosxr")
               self.parent.parameters['isis_neighbours'][device.name] = int(table_dict.entries['Up']['0']['L2'])

    @aetest.test
    def check_isis_neighbours_amount(self):

        for device in self.parent.parameters['dev']:
                assert self.parent.parameters['isis_neighbours'][device.name] == 1

if __name__ == '__main__':
    aetest.main()
